import Alamofire
import XCTest

@testable import PutioSDK

final class PutioSDKRequestConfigTests: XCTestCase {
    func testRequestConfigAddsTokenAuthorizationAndEncodesQuery() {
        let request = PutioSDKRequestConfig(
            apiConfig: PutioSDKConfig(clientID: "ios-app", token: "token-123"),
            url: "/files/list",
            method: .get,
            query: ["parent_id": 0, "name": "hello world"]
        )

        XCTAssertEqual(request.headers.value(for: "authorization"), "token token-123")

        let components = URLComponents(string: request.url)
        let queryItems = components?.queryItems ?? []
        XCTAssertEqual(components?.scheme, "https")
        XCTAssertEqual(components?.host, "api.put.io")
        XCTAssertEqual(components?.path, "/v2/files/list")
        XCTAssertEqual(queryItems.first(where: { $0.name == "parent_id" })?.value, "0")
        XCTAssertEqual(queryItems.first(where: { $0.name == "name" })?.value, "hello world")
    }

    func testRequestConfigPreservesExplicitAuthorizationHeader() {
        let request = PutioSDKRequestConfig(
            apiConfig: PutioSDKConfig(clientID: "ios-app", token: "token-123"),
            url: "/account/info",
            method: .get,
            headers: HTTPHeaders(["Authorization": "Bearer custom-token"])
        )

        XCTAssertEqual(request.headers.value(for: "authorization"), "Bearer custom-token")
    }

    func testRequestConfigCanSuppressConfiguredAuthorizationHeader() {
        let request = PutioSDKRequestConfig(
            apiConfig: PutioSDKConfig(clientID: "ios-app", token: "token-123"),
            url: "/two_factor/verify/totp",
            method: .post,
            headers: HTTPHeaders(["Authorization": ""])
        )

        XCTAssertEqual(request.headers.value(for: "authorization"), "")
    }
}
