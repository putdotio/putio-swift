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
        self.init(
            baseURL: PutioSDK.apiURL,
            clientID: clientID,
            clientSecret: clientSecret,
            clientName: clientName,
            token: token,
            timeoutInterval: timeoutInterval
        )
    }

    public init(
        baseURL: String,
        clientID: String,
        clientSecret: String = "",
        clientName: String = "",
        token: String = "",
        timeoutInterval: Double = 15.0
    ) {
        self.baseURL = baseURL
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
    case httpError(statusCode: Int, errorType: String?)
    case networkError
    case decodingError
    case unknownError
}

public struct PutioSDKErrorRequestInformation {
    let config: PutioSDKRequestConfig
}

internal struct PutioAPIErrorEnvelope: Decodable {
    let message: String?
    let errorMessage: String?
    let statusCode: Int?
    let errorType: String?

    enum CodingKeys: String, CodingKey {
        case message
        case errorMessage = "error_message"
        case statusCode = "status_code"
        case errorType = "error_type"
    }

    var resolvedMessage: String? {
        message ?? errorMessage
    }
}

public struct PutioSDKError: Error, LocalizedError {
    public let request: PutioSDKErrorRequestInformation
    public let type: PutioSDKErrorType
    public let message: String
    public let underlyingError: Error
    public let responseBody: String?

    public var errorDescription: String? {
        message
    }

    public var failureReason: String? {
        switch type {
        case let .httpError(statusCode, errorType):
            if let errorType, !errorType.isEmpty {
                return "put.io rejected \(request.config.method.rawValue) \(request.config.url) with HTTP \(statusCode) and error type \(errorType)."
            }

            return "put.io rejected \(request.config.method.rawValue) \(request.config.url) with HTTP \(statusCode)."
        case .networkError:
            return "The SDK could not reach put.io."
        case .decodingError:
            return "put.io responded, but the payload did not match the SDK contract."
        case .unknownError:
            return "The SDK failed before it could classify the error."
        }
    }

    public var recoverySuggestion: String? {
        switch type {
        case let .httpError(statusCode, _):
            switch statusCode {
            case 401, 403:
                return "Sign in again or refresh the access token, then retry the request."
            case 404:
                return "Verify the resource identifier and retry. The item may already be deleted or moved."
            case 429:
                return "Wait briefly before retrying. put.io is rate-limiting this request."
            default:
                return "Retry the request. If it keeps failing, inspect the attached status code and response body."
            }
        case .networkError:
            return "Check connectivity and retry. If you are offline or behind a restrictive network, wait for the connection to recover."
        case .decodingError:
            return "Upgrade the SDK or inspect the raw response body to confirm whether the backend contract changed."
        case .unknownError:
            return "Retry the request and inspect the underlying error for operator details."
        }
    }

    init(request: PutioSDKErrorRequestInformation, errorJSON: JSON, error: AFError, responseBody: String? = nil) {
        self.request = request
        self.type = .httpError(statusCode: errorJSON["status_code"].intValue, errorType: errorJSON["error_type"].string)
        self.message = errorJSON["message"].stringValue
        self.underlyingError = error
        self.responseBody = responseBody
    }

    init(
        request: PutioSDKErrorRequestInformation,
        statusCode: Int,
        errorType: String?,
        message: String,
        underlyingError: Error,
        responseBody: String? = nil
    ) {
        self.request = request
        self.type = .httpError(statusCode: statusCode, errorType: errorType)
        self.message = message
        self.underlyingError = underlyingError
        self.responseBody = responseBody
    }

    init(request: PutioSDKErrorRequestInformation, error: Error) {
        self.request = request
        self.type = .networkError
        self.message = error.localizedDescription
        self.underlyingError = error
        self.responseBody = nil
    }

    init(request: PutioSDKErrorRequestInformation, decodingError: Error, responseBody: String) {
        self.request = request
        self.type = .decodingError
        self.message = decodingError.localizedDescription
        self.underlyingError = decodingError
        self.responseBody = responseBody
    }

    init(request: PutioSDKErrorRequestInformation, unknownError error: Error) {
        self.request = request
        self.type = .unknownError
        self.message = error.localizedDescription
        self.underlyingError = error
        self.responseBody = nil
    }
}

public struct PutioOKResponse: Codable {
    public let status: String
    public let cursor: String?
    public let skipped: Int?
}

public typealias PutioSDKBoolCompletion = (Result<JSON, PutioSDKError>) -> Void
