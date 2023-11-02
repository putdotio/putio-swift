import Foundation
import Alamofire
import SwiftyJSON

public struct PutioAPIConfig {
    public let baseURL: String
    public var token: String
    public var clientID: String
    public var clientSecret: String
    public var clientName: String
    public var timeoutInterval: Double

    public init(clientID: String, clientSecret: String = "", clientName: String = "", token: String = "", timeoutInterval: Double = 15.0) {
        self.baseURL = PutioAPI.apiURL
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.clientName = clientName
        self.token = token
        self.timeoutInterval = timeoutInterval
    }
}

public struct PutioAPIRequestConfig {
    let url: String
    let method: HTTPMethod
    let headers: HTTPHeaders
    let query: Parameters
    let body: Parameters?

    init(apiConfig: PutioAPIConfig, url: String, method: HTTPMethod, headers: HTTPHeaders = [:], query: Parameters = [:], body: Parameters = [:]) {
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

public enum PutioAPIErrorType {
    case httpError(statusCode: Int, errorType: String)
    case networkError
    case unknownError
}

public struct PutiopAPIErrorRequestInformation {
    let config: PutioAPIRequestConfig
}

public struct PutioAPIError: Error {
    public let request: PutiopAPIErrorRequestInformation
    public let type: PutioAPIErrorType
    public let message: String
    public let underlyingError: Error

    init(request: PutiopAPIErrorRequestInformation, errorJSON: JSON, error: AFError) {
        self.request = request
        self.type = .httpError(statusCode: errorJSON["status_code"].intValue, errorType: errorJSON["error_type"].stringValue)
        self.message = errorJSON["message"].stringValue
        self.underlyingError = error
    }

    init(request: PutiopAPIErrorRequestInformation, error: AFError) {
        self.request = request
        self.type = .networkError
        self.message = error.localizedDescription
        self.underlyingError = error
    }

    init(request: PutiopAPIErrorRequestInformation, error: Error) {
        self.request = request
        self.type = .unknownError
        self.message = error.localizedDescription
        self.underlyingError = error
    }
}

public typealias PutioAPIBoolCompletion = (Result<JSON, PutioAPIError>) -> Void
