import Foundation
import Alamofire
import SwiftyJSON

public struct PutioSDKConfig {
    public let baseURL: String
    public var token: String
    public var clientID: String
    public var clientSecret: String
    public var clientName: String
    public var timeoutInterval: Double

    public init(clientID: String, clientSecret: String = "", clientName: String = "", token: String = "", timeoutInterval: Double = 15.0) {
        self.baseURL = PutioSDK.apiURL
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.clientName = clientName
        self.token = token
        self.timeoutInterval = timeoutInterval
    }
}

public struct PutioSDKRequestConfig {
    let url: String
    let method: HTTPMethod
    let headers: HTTPHeaders
    let query: Parameters
    let body: Parameters?

    init(apiConfig: PutioSDKConfig, url: String, method: HTTPMethod, headers: HTTPHeaders = [:], query: Parameters = [:], body: Parameters = [:]) {
        if (query.isEmpty) {
            self.url = "\(apiConfig.baseURL)\(url)"
        } else {
            let encodedURLRequest = try! URLEncoding.queryString.encode(URLRequest(url: URL(string: url)!), with: query)
            self.url = "\(apiConfig.baseURL)\((encodedURLRequest.url?.absoluteString)!)"
        }

        self.method = method

        var enhancedHeaders = headers
        if enhancedHeaders.value(for: "authorization") == nil {
            if apiConfig.token != "" {
                let authorizationHeader = HTTPHeader.authorization("token \(apiConfig.token)")
                enhancedHeaders.add(authorizationHeader)
            }
        }

        self.headers = enhancedHeaders

        self.query = query

        switch method {
        case .post, .put, .patch:
            self.body = body
        default:
            self.body = nil
        }
    }
}

public enum PutioSDKErrorType {
    case httpError(statusCode: Int, errorType: String)
    case networkError
    case unknownError
}

public struct PutioSDKErrorRequestInformation {
    let config: PutioSDKRequestConfig
}

public struct PutioSDKError: Error {
    public let request: PutioSDKErrorRequestInformation
    public let type: PutioSDKErrorType
    public let message: String
    public let underlyingError: Error

    init(request: PutioSDKErrorRequestInformation, errorJSON: JSON, error: AFError) {
        self.request = request
        self.type = .httpError(statusCode: errorJSON["status_code"].intValue, errorType: errorJSON["error_type"].stringValue)
        self.message = errorJSON["message"].stringValue
        self.underlyingError = error
    }

    init(request: PutioSDKErrorRequestInformation, error: AFError) {
        self.request = request
        self.type = .networkError
        self.message = error.localizedDescription
        self.underlyingError = error
    }

    init(request: PutioSDKErrorRequestInformation, error: Error) {
        self.request = request
        self.type = .unknownError
        self.message = error.localizedDescription
        self.underlyingError = error
    }
}

public typealias PutioSDKBoolCompletion = (Result<JSON, PutioSDKError>) -> Void
