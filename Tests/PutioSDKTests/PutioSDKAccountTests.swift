import XCTest

@testable import PutioSDK

final class PutioSDKAccountTests: XCTestCase {
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testAccountEndpointsDecodeSettingsAndMutationBodies() async throws {
        MockURLProtocol.requestHandler = { request in
            switch request.url?.path {
            case "/v2/account/settings":
                if request.httpMethod == "GET" {
                    let payload = """
                    {
                      "settings": {
                        "tunnel_route_name": "eu-west",
                        "next_episode": true,
                        "start_from": true,
                        "history_enabled": true,
                        "trash_enabled": true,
                        "sort_by": "NAME_ASC",
                        "show_optimistic_usage": true,
                        "two_factor_enabled": true,
                        "hide_subtitles": false,
                        "dont_autoselect_subtitles": true
                      }
                    }
                    """
                    return (makeHTTPResponse(for: request, statusCode: 200), Data(payload.utf8))
                }

                XCTFail("saveAccountSettings is covered elsewhere and should not hit this test")
                return (makeHTTPResponse(for: request, statusCode: 500), Data())
            case "/v2/account/clear":
                XCTAssertEqual(request.httpMethod, "POST")
                let body = try XCTUnwrap(requestBodyData(for: request))
                let json = try XCTUnwrap(JSONSerialization.jsonObject(with: body) as? [String: Bool])
                XCTAssertEqual(json["files"], true)
                XCTAssertEqual(json["history"], false)
                return (makeHTTPResponse(for: request, statusCode: 200), Data(#"{"status":"OK"}"#.utf8))
            case "/v2/account/destroy":
                XCTAssertEqual(request.httpMethod, "POST")
                let body = try XCTUnwrap(requestBodyData(for: request))
                let json = try XCTUnwrap(JSONSerialization.jsonObject(with: body) as? [String: String])
                XCTAssertEqual(json["current_password"], "secret-123")
                return (makeHTTPResponse(for: request, statusCode: 200), Data(#"{"status":"OK","skipped":0}"#.utf8))
            default:
                XCTFail("Unexpected account path \(request.url?.path ?? "<nil>")")
                return (makeHTTPResponse(for: request, statusCode: 404), Data())
            }
        }

        let sdk = PutioSDK(
            config: PutioSDKConfig(clientID: "ios-app", token: "token-123"),
            urlSession: makeTestSession()
        )

        let settings = try await sdk.getAccountSettings()
        let cleared = try await sdk.clearAccountData(options: ["files": true, "history": false])
        let destroyed = try await sdk.destroyAccount(currentPassword: "secret-123")

        XCTAssertEqual(settings.routeName, "eu-west")
        XCTAssertTrue(settings.historyEnabled)
        XCTAssertTrue(settings.dontAutoSelectSubtitles)
        XCTAssertEqual(cleared.status, "OK")
        XCTAssertEqual(destroyed.status, "OK")
        XCTAssertEqual(destroyed.skipped, 0)
    }

    func testAccountModelsDecodeDefaultsAndClearDataOptionKeysStayStable() throws {
        let decoder = JSONDecoder()

        let settings = try decoder.decode(
            PutioAccount.Settings.self,
            from: Data(
                """
                {
                  "sort_by": "NAME_ASC"
                }
                """.utf8
            )
        )
        let account = try decoder.decode(
            PutioAccount.self,
            from: Data(
                """
                {
                  "user_id": 1,
                  "username": "alice",
                  "mail": "alice@example.com",
                  "disk": {
                    "avail": 100,
                    "size": 200,
                    "used": 100
                  },
                  "settings": {
                    "sort_by": "NAME_ASC"
                  }
                }
                """.utf8
            )
        )

        XCTAssertEqual(settings.routeName, "default")
        XCTAssertFalse(settings.historyEnabled)
        XCTAssertFalse(settings.trashEnabled)
        XCTAssertFalse(settings.twoFactorEnabled)
        XCTAssertEqual(account.avatarURL, "")
        XCTAssertEqual(account.hash, "")
        XCTAssertEqual(account.downloadToken, "")
        XCTAssertEqual(account.trashSize, 0)
        XCTAssertEqual(account.features, [:])
        XCTAssertEqual(account.filesWillBeDeletedAt, "")
        XCTAssertEqual(account.passwordLastChangedAt, "")
        XCTAssertTrue(PutioClearDataOptionKeys.contains("history"))
        XCTAssertTrue(PutioClearDataOptionKeys.contains("trash"))
    }
}
