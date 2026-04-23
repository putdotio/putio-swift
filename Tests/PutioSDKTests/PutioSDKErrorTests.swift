import Alamofire
import XCTest

@testable import PutioSDK

final class PutioSDKErrorTests: XCTestCase {
    private final class DelegateProbe: PutioSDKDelegate {
        var errors: [PutioSDKError] = []

        func onPutioSDKError(error: PutioSDKError) {
            errors.append(error)
        }
    }

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testTypedErrorsExposeHelpfulFailureReasonsAndRecovery() {
        let requestConfig = PutioSDKRequestConfig(
            apiConfig: PutioSDKConfig(clientID: "ios-app", token: "token-123"),
            url: "/files/42",
            method: .get
        )
        let requestInfo = PutioSDKErrorRequestInformation(config: requestConfig)

        let unauthorized = PutioSDKError(
            request: requestInfo,
            statusCode: 401,
            errorType: "UNAUTHORIZED",
            message: "unauthorized",
            underlyingError: URLError(.userAuthenticationRequired),
            responseBody: #"{"status":"ERROR"}"#
        )
        let rateLimited = PutioSDKError(
            request: requestInfo,
            statusCode: 429,
            errorType: nil,
            message: "slow down",
            underlyingError: URLError(.badServerResponse)
        )
        let serverError = PutioSDKError(
            request: requestInfo,
            statusCode: 500,
            errorType: nil,
            message: "server error",
            underlyingError: URLError(.badServerResponse)
        )
        let networkError = PutioSDKError(request: requestInfo, error: URLError(.notConnectedToInternet))
        let decodingError = PutioSDKError(
            request: requestInfo,
            decodingError: DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "broken")),
            responseBody: "{}"
        )
        let unknownError = PutioSDKError(request: requestInfo, unknownError: URLError(.badURL))

        XCTAssertEqual(unauthorized.errorDescription, "unauthorized")
        XCTAssertTrue(unauthorized.failureReason?.contains("HTTP 401") == true)
        XCTAssertEqual(unauthorized.recoverySuggestion, "Sign in again or refresh the access token, then retry the request.")
        XCTAssertEqual(rateLimited.recoverySuggestion, "Wait briefly before retrying. put.io is rate-limiting this request.")
        XCTAssertEqual(serverError.recoverySuggestion, "Retry the request. If it keeps failing, inspect the attached status code and response body.")
        XCTAssertEqual(networkError.failureReason, "The SDK could not reach put.io.")
        XCTAssertTrue(networkError.recoverySuggestion?.contains("Check connectivity") == true)
        XCTAssertEqual(decodingError.failureReason, "put.io responded, but the payload did not match the SDK contract.")
        XCTAssertTrue(decodingError.recoverySuggestion?.contains("Upgrade the SDK") == true)
        XCTAssertEqual(unknownError.failureReason, "The SDK failed before it could classify the error.")
        XCTAssertTrue(unknownError.recoverySuggestion?.contains("underlying error") == true)
    }

    func testErrorDescriptionsRedactSensitiveRequestData() {
        let requestConfig = PutioSDKRequestConfig(
            apiConfig: PutioSDKConfig(baseURL: "https://api.put.io/v2", clientID: "ios-app", token: "config-token"),
            url: "/two_factor/verify/totp",
            method: .post,
            headers: HTTPHeaders(["Authorization": "Bearer header-token"]),
            query: ["oauth_token": "query-token"],
            body: ["client_secret": "client-secret", "name": "safe-name"]
        )
        let requestInfo = PutioSDKErrorRequestInformation(config: requestConfig)
        let error = PutioSDKError(
            request: requestInfo,
            statusCode: 401,
            errorType: "invalid_scope",
            message: "invalid scope",
            underlyingError: URLError(.userAuthenticationRequired)
        )

        let description = String(describing: error)

        XCTAssertFalse(description.contains("config-token"))
        XCTAssertFalse(description.contains("header-token"))
        XCTAssertFalse(description.contains("query-token"))
        XCTAssertFalse(description.contains("client-secret"))
        XCTAssertTrue(description.contains("safe-name"))
        XCTAssertTrue(description.contains("<redacted>"))
        XCTAssertFalse(error.failureReason?.contains("query-token") == true)
    }

    func testTransportNotifiesDelegateForNetworkAndDecodingFailures() async throws {
        let delegate = DelegateProbe()

        MockURLProtocol.requestHandler = { request in
            switch request.url?.path {
            case "/v2/account/info":
                throw URLError(.notConnectedToInternet)
            default:
                XCTFail("Unexpected path \(request.url?.path ?? "<nil>")")
                return (makeHTTPResponse(for: request, statusCode: 404), Data())
            }
        }

        let sdk = PutioSDK(
            config: PutioSDKConfig(clientID: "ios-app", token: "token-123"),
            urlSession: makeTestSession()
        )
        sdk.delegate = delegate

        do {
            _ = try await sdk.getAccountInfo()
            XCTFail("Expected network failure")
        } catch let error as PutioSDKError {
            switch error.type {
            case .networkError:
                break
            default:
                XCTFail("Expected networkError, got \(error.type)")
            }
        }

        MockURLProtocol.requestHandler = { request in
            switch request.url?.path {
            case "/v2/account/info":
                return (makeHTTPResponse(for: request, statusCode: 200), Data(#"{"info":{}}"#.utf8))
            default:
                XCTFail("Unexpected path \(request.url?.path ?? "<nil>")")
                return (makeHTTPResponse(for: request, statusCode: 404), Data())
            }
        }

        do {
            _ = try await sdk.getAccountInfo()
            XCTFail("Expected decoding failure")
        } catch let error as PutioSDKError {
            switch error.type {
            case .decodingError:
                XCTAssertEqual(error.responseBody, #"{"info":{}}"#)
            default:
                XCTFail("Expected decodingError, got \(error.type)")
            }
        }

        XCTAssertEqual(delegate.errors.count, 2)
    }

    func testInvalidBaseURLSurfacesUnknownError() async throws {
        let sdk = PutioSDK(
            config: PutioSDKConfig(baseURL: "http://[::1", clientID: "ios-app", token: "token-123"),
            urlSession: makeTestSession()
        )

        do {
            _ = try await sdk.getAccountInfo()
            XCTFail("Expected invalid URL to fail")
        } catch let error as PutioSDKError {
            switch error.type {
            case .unknownError:
                XCTAssertEqual(error.message, URLError(.badURL).localizedDescription)
            default:
                XCTFail("Expected unknownError, got \(error.type)")
            }
        }
    }
}
