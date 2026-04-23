import Foundation
import Alamofire

extension PutioSDK {
    public func getAccountInfo(query: Parameters = [:]) async throws -> PutioAccount {
        let envelope = try await request("/account/info", query: query, as: PutioAccountInfoEnvelope.self)
        return envelope.info
    }

    public func getAccountSettings() async throws -> PutioAccount.Settings {
        let envelope = try await request("/account/settings", query: [:], as: PutioAccountSettingsEnvelope.self)
        return envelope.settings
    }

    public func saveAccountSettings(body: [String: Any]) async throws -> PutioOKResponse {
        try await request("/account/settings", method: .post, body: body, as: PutioOKResponse.self)
    }

    public func clearAccountData(options: [String: Bool]) async throws -> PutioOKResponse {
        try await request("/account/clear", method: .post, body: options, as: PutioOKResponse.self)
    }

    public func destroyAccount(currentPassword: String) async throws -> PutioOKResponse {
        try await request("/account/destroy", method: .post, body: ["current_password": currentPassword], as: PutioOKResponse.self)
    }
}

private struct PutioAccountInfoEnvelope: Decodable {
    let info: PutioAccount
}

private struct PutioAccountSettingsEnvelope: Decodable {
    let settings: PutioAccount.Settings
}
