import XCTest

@testable import PutioSDK

final class PutioSDKTransportTests: XCTestCase {
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testGetAccountInfoParsesResponseThroughSharedTransport() async throws {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "token token-123")
            XCTAssertEqual(request.url?.path, "/v2/account/info")

            let payload = """
            {
              "info": {
                "user_id": 1,
                "username": "alice",
                "mail": "alice@example.com",
                "avatar_url": "https://example.com/avatar.png",
                "user_hash": "hash",
                "features": {
                  "beta": true
                },
                "download_token": "download-token",
                "trash_size": 0,
                "account_active": true,
                "files_will_be_deleted_at": "",
                "password_last_changed_at": "",
                "disk": {
                  "avail": 100,
                  "size": 200,
                  "used": 100
                },
                "settings": {
                  "tunnel_route_name": "",
                  "next_episode": true,
                  "start_from": true,
                  "history_enabled": true,
                  "trash_enabled": true,
                  "sort_by": "name",
                  "show_optimistic_usage": false,
                  "two_factor_enabled": false,
                  "hide_subtitles": false,
                  "dont_autoselect_subtitles": false
                }
              }
            }
            """

            return (makeHTTPResponse(for: request, statusCode: 200), Data(payload.utf8))
        }

        let sdk = PutioSDK(
            config: PutioSDKConfig(clientID: "ios-app", token: "token-123"),
            urlSession: makeTestSession()
        )

        let account = try await sdk.getAccountInfo()

        XCTAssertEqual(account.username, "alice")
        XCTAssertEqual(account.disk.available, 100)
        XCTAssertTrue(account.settings.historyEnabled)
    }

    func testGetFileSurfacesTypedHttpErrors() async throws {
        MockURLProtocol.requestHandler = { request in
            let payload = """
            {
              "status": "ERROR",
              "status_code": 404,
              "error_type": "NOT_FOUND",
              "message": "file not found"
            }
            """

            return (makeHTTPResponse(for: request, statusCode: 404), Data(payload.utf8))
        }

        let sdk = PutioSDK(
            config: PutioSDKConfig(clientID: "ios-app", token: "token-123"),
            urlSession: makeTestSession()
        )

        do {
            _ = try await sdk.getFile(fileID: 99)
            XCTFail("Expected getFile to fail")
        } catch let error as PutioSDKError {
            switch error.type {
            case let .httpError(statusCode, errorType):
                XCTAssertEqual(statusCode, 404)
                XCTAssertEqual(errorType, "NOT_FOUND")
                XCTAssertEqual(error.message, "file not found")
                XCTAssertEqual(error.errorDescription, "file not found")
                XCTAssertTrue(error.failureReason?.contains("HTTP 404") == true)
                XCTAssertTrue(error.failureReason?.contains("NOT_FOUND") == true)
                XCTAssertEqual(error.recoverySuggestion, "Verify the resource identifier and retry. The item may already be deleted or moved.")
            default:
                XCTFail("Expected an httpError, got \(error.type)")
            }
        }
    }

    func testUnknownFileTypePreservesRawValue() throws {
        let file = try JSONDecoder().decode(PutioFile.self, from: Data("""
        {
          "id": 1,
          "name": "Mystery",
          "icon": "icon",
          "parent_id": 0,
          "size": 0,
          "created_at": "2026-04-20T10:00:00Z",
          "updated_at": "2026-04-20T10:00:00Z",
          "is_shared": false,
          "file_type": "BOOK"
        }
        """.utf8))

        XCTAssertEqual(file.type.rawValue, "BOOK")
        XCTAssertFalse(file.type.isKnown)
    }
}
