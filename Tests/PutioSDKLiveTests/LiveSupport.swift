import Foundation
import XCTest

@testable import PutioSDK

enum LiveSupport {
    static func newAuthedClient() throws -> PutioSDK {
        let token = try requiredValue("PUTIO_TOKEN_FIRST_PARTY", aliases: ["PUTIO_ACCESS_TOKEN", "PUTIO_TOKEN"])
        let clientID = try runtimeValue("PUTIO_CLIENT_ID") ?? ""
        let baseURL = env("PUTIO_BASE_URL")

        var config = PutioSDKConfig(clientID: clientID, token: token)
        if let baseURL {
            config = PutioSDKConfig(
                baseURL: baseURL,
                clientID: clientID,
                clientSecret: "",
                clientName: "",
                token: token,
                timeoutInterval: 15.0
            )
        }

        return PutioSDK(config: config)
    }

    static func uniqueName(prefix: String) -> String {
        "\(prefix)-\(UUID().uuidString.prefix(12))"
    }

    private static func env(_ name: String) -> String? {
        ProcessInfo.processInfo.environment[name]?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
    }

    private static func requiredValue(_ primary: String, aliases: [String] = []) throws -> String {
        if let value = try runtimeValue(primary, aliases: aliases) {
            return value
        }

        throw XCTSkip("Missing live-test credential env: \(primary)")
    }

    private static func runtimeValue(_ primary: String, aliases: [String] = []) throws -> String? {
        for key in [primary] + aliases {
            if let value = env(key) {
                return value
            }
        }

        switch primary {
        case "PUTIO_TOKEN_FIRST_PARTY":
            return try runtimeFieldValue(label: "access_token", sectionLabel: "first_party")
        case "PUTIO_CLIENT_ID":
            return try runtimeFieldValue(label: "app_id", sectionLabel: "third_party")
                ?? runtimeFieldValue(label: "third_party_app_id", sectionLabel: nil)
        default:
            return nil
        }
    }

    private static func runtimeFieldValue(label: String, sectionLabel: String?) throws -> String? {
        guard let fields = try runtimeItemFields() else {
            return nil
        }

        return fields.first { field in
            let fieldLabel = field["label"] as? String
            let section = (field["section"] as? [String: Any])?["label"] as? String
            return fieldLabel == label && section == sectionLabel
        }?["value"] as? String
    }

    private static func runtimeItemFields() throws -> [[String: Any]]? {
        guard
            let runtimeItemID = env("PUTIO_1PASSWORD_RUNTIME_ITEM_ID"),
            let runtimeItemVault = env("PUTIO_1PASSWORD_RUNTIME_VAULT"),
            env("OP_SERVICE_ACCOUNT_TOKEN") != nil
        else {
            return nil
        }

        let process = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [
            "op",
            "item",
            "get",
            runtimeItemID,
            "--vault",
            runtimeItemVault,
            "--format",
            "json",
            "--reveal",
        ]
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        try process.run()
        process.waitUntilExit()

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        guard process.terminationStatus == 0 else {
            let errorText = String(data: errorData, encoding: .utf8) ?? "unknown op error"
            throw XCTSkip("Unable to read 1Password runtime item: \(errorText)")
        }

        let json = try JSONSerialization.jsonObject(with: outputData) as? [String: Any]
        return json?["fields"] as? [[String: Any]]
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
