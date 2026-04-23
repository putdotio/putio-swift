import XCTest

@testable import PutioSDK

final class PutioSDKAuthTests: XCTestCase {
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testGetAuthURLBuildsExpectedQueryItems() throws {
        let sdk = PutioSDK(
            config: PutioSDKConfig(clientID: "ios-app", clientName: "put.io TV + Beta", token: "session-token"),
            urlSession: makeTestSession()
        )

        let url = sdk.getAuthURL(redirectURI: "putio://oauth/callback", responseType: "code", state: "csrf-token")
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let query = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value ?? "") })

        XCTAssertEqual(components.path, "/v2/oauth2/authenticate")
        XCTAssertEqual(query["client_id"], "ios-app")
        XCTAssertEqual(query["client_name"], "put.io TV + Beta")
        XCTAssertEqual(query["redirect_uri"], "putio://oauth/callback")
        XCTAssertEqual(query["response_type"], "code")
        XCTAssertEqual(query["state"], "csrf-token")
    }

    func testAuthAndTwoFactorEndpointsDecodeTypedResponses() async throws {
        var seenPaths: [String] = []

        MockURLProtocol.requestHandler = { request in
            let path = request.url?.path ?? ""
            seenPaths.append(path)

            switch path {
            case "/v2/oauth2/oob/code":
                XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"))
                let components = URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false)
                XCTAssertEqual(components?.queryItems?.first(where: { $0.name == "app_id" })?.value, "ios-app")
                XCTAssertEqual(components?.queryItems?.first(where: { $0.name == "client_name" })?.value, "put.io TV + Beta")
                return (makeHTTPResponse(for: request, statusCode: 200), Data(#"{"code":"code-123"}"#.utf8))
            case "/v2/oauth2/oob/code/code-123":
                XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"))
                return (makeHTTPResponse(for: request, statusCode: 200), Data(#"{"oauth_token":"oauth-token-456"}"#.utf8))
            case "/v2/oauth2/validate":
                XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Token external-token")
                let payload = """
                {
                  "result": true,
                  "token_id": 44,
                  "token_scope": "stream",
                  "user_id": 12
                }
                """
                return (makeHTTPResponse(for: request, statusCode: 200), Data(payload.utf8))
            case "/v2/oauth/grants/logout":
                XCTAssertEqual(request.httpMethod, "POST")
                return (makeHTTPResponse(for: request, statusCode: 200), Data(#"{"status":"OK"}"#.utf8))
            case "/v2/two_factor/generate/totp":
                XCTAssertEqual(request.httpMethod, "POST")
                let payload = """
                {
                  "secret": "secret-123",
                  "uri": "otpauth://totp/put.io",
                  "recovery_codes": {
                    "created_at": "2026-04-23T10:00:00Z",
                    "codes": [
                      { "code": "rc-1", "used_at": null }
                    ]
                  }
                }
                """
                return (makeHTTPResponse(for: request, statusCode: 200), Data(payload.utf8))
            case "/v2/two_factor/verify/totp":
                XCTAssertEqual(request.httpMethod, "POST")
                XCTAssertNil(request.value(forHTTPHeaderField: "Authorization"))
                let components = URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false)
                XCTAssertEqual(components?.queryItems?.first(where: { $0.name == "oauth_token" })?.value, "two-factor-token")
                let body = try XCTUnwrap(requestBodyData(for: request))
                let json = try XCTUnwrap(JSONSerialization.jsonObject(with: body) as? [String: String])
                XCTAssertEqual(json["code"], "123456")
                return (makeHTTPResponse(for: request, statusCode: 200), Data(#"{"token":"verified-token","user_id":12}"#.utf8))
            case "/v2/two_factor/recovery_codes":
                let payload = """
                {
                  "recovery_codes": {
                    "created_at": "2026-04-23T10:00:00Z",
                    "codes": [
                      { "code": "rc-1", "used_at": "2026-04-22T10:00:00Z" },
                      { "code": "rc-2", "used_at": null }
                    ]
                  }
                }
                """
                return (makeHTTPResponse(for: request, statusCode: 200), Data(payload.utf8))
            case "/v2/two_factor/recovery_codes/refresh":
                XCTAssertEqual(request.httpMethod, "POST")
                let payload = """
                {
                  "recovery_codes": {
                    "created_at": "2026-04-24T10:00:00Z",
                    "codes": [
                      { "code": "rc-3", "used_at": null }
                    ]
                  }
                }
                """
                return (makeHTTPResponse(for: request, statusCode: 200), Data(payload.utf8))
            default:
                XCTFail("Unexpected auth path \(path)")
                return (makeHTTPResponse(for: request, statusCode: 404), Data())
            }
        }

        let sdk = PutioSDK(
            config: PutioSDKConfig(clientID: "ios-app", clientName: "put.io TV + Beta", token: "session-token"),
            urlSession: makeTestSession()
        )

        let code = try await sdk.getAuthCode()
        let token = try await sdk.checkAuthCodeMatch(code: code)
        let validation = try await sdk.validateToken(token: "external-token")
        let logout = try await sdk.logout()
        let generated = try await sdk.generateTOTP()
        let verified = try await sdk.verifyTOTP(twoFactorScopedToken: "two-factor-token", code: "123456")
        let recoveryCodes = try await sdk.getRecoveryCodes()
        let refreshedRecoveryCodes = try await sdk.regenerateRecoveryCodes()

        XCTAssertEqual(code, "code-123")
        XCTAssertEqual(token, "oauth-token-456")
        XCTAssertTrue(validation.result)
        XCTAssertEqual(validation.token_id, 44)
        XCTAssertEqual(validation.token_scope, "stream")
        XCTAssertEqual(validation.user_id, 12)
        XCTAssertEqual(logout.status, "OK")
        XCTAssertEqual(generated.secret, "secret-123")
        XCTAssertEqual(generated.uri, "otpauth://totp/put.io")
        XCTAssertEqual(generated.recovery_codes.codes.first?.code, "rc-1")
        XCTAssertEqual(verified.token, "verified-token")
        XCTAssertEqual(verified.user_id, 12)
        XCTAssertEqual(recoveryCodes.created_at, "2026-04-23T10:00:00Z")
        XCTAssertEqual(recoveryCodes.codes.count, 2)
        XCTAssertEqual(recoveryCodes.codes.first?.used_at, "2026-04-22T10:00:00Z")
        XCTAssertEqual(refreshedRecoveryCodes.codes.map(\.code), ["rc-3"])
        XCTAssertEqual(
            seenPaths,
            [
                "/v2/oauth2/oob/code",
                "/v2/oauth2/oob/code/code-123",
                "/v2/oauth2/validate",
                "/v2/oauth/grants/logout",
                "/v2/two_factor/generate/totp",
                "/v2/two_factor/verify/totp",
                "/v2/two_factor/recovery_codes",
                "/v2/two_factor/recovery_codes/refresh",
            ]
        )
    }

    func testAuthModelsDecodeGracefulDefaults() throws {
        let decoder = JSONDecoder()

        let validation = try decoder.decode(PutioTokenValidationResult.self, from: Data(#"{}"#.utf8))
        let recoveryCodes = try decoder.decode(PutioTwoFactorRecoveryCodes.self, from: Data(#"{}"#.utf8))
        let verification = try decoder.decode(PutioVerifyTOTPResult.self, from: Data(#"{}"#.utf8))

        XCTAssertFalse(validation.result)
        XCTAssertEqual(validation.token_id, 0)
        XCTAssertEqual(validation.token_scope, "")
        XCTAssertEqual(validation.user_id, 0)
        XCTAssertEqual(recoveryCodes.created_at, "")
        XCTAssertTrue(recoveryCodes.codes.isEmpty)
        XCTAssertEqual(verification.token, "")
        XCTAssertEqual(verification.user_id, 0)
    }
}
