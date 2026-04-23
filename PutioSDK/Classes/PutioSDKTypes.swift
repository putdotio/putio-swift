import Foundation
import Alamofire

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

extension PutioSDKRequestConfig: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "PutioSDKRequestConfig(url: \"\(redactedURL)\", method: \(method.rawValue), headers: \(redactedHeaders), query: \(redact(query)), body: \(redact(body ?? [:])))"
    }

    public var debugDescription: String {
        description
    }

    var redactedURL: String {
        guard var components = URLComponents(string: url), let queryItems = components.queryItems else {
            return url
        }

        components.queryItems = queryItems.map { item in
            sensitiveKey(item.name) ? URLQueryItem(name: item.name, value: "<redacted>") : item
        }
        return components.string ?? url
    }

    private var redactedHeaders: HTTPHeaders {
        HTTPHeaders(headers.map { header in
            if sensitiveKey(header.name) {
                return HTTPHeader(name: header.name, value: "<redacted>")
            }
            return header
        })
    }
}

extension PutioSDKErrorRequestInformation: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "PutioSDKErrorRequestInformation(config: \(config))"
    }

    public var debugDescription: String {
        description
    }
}

private func redact(_ parameters: Parameters) -> Parameters {
    var redacted = Parameters()
    for (key, value) in parameters {
        redacted[key] = sensitiveKey(key) ? "<redacted>" : value
    }
    return redacted
}

private func sensitiveKey(_ key: String) -> Bool {
    let normalized = key.lowercased()
    return normalized == "authorization" ||
        normalized == "token" ||
        normalized == "oauth_token" ||
        normalized == "access_token" ||
        normalized == "client_secret" ||
        normalized.hasSuffix("_token")
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

public struct PutioSDKError: Error, LocalizedError, CustomStringConvertible, CustomDebugStringConvertible {
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
                return "put.io rejected \(request.config.method.rawValue) \(request.config.redactedURL) with HTTP \(statusCode) and error type \(errorType)."
            }

            return "put.io rejected \(request.config.method.rawValue) \(request.config.redactedURL) with HTTP \(statusCode)."
        case .networkError:
            return "The SDK could not reach put.io."
        case .decodingError:
            return "put.io responded, but the payload did not match the SDK contract."
        case .unknownError:
            return "The SDK failed before it could classify the error."
        }
    }

    public var description: String {
        "PutioSDKError(request: \(request), type: \(type), message: \"\(message)\", underlyingError: \(underlyingError), responseBody: \(responseBody ?? "nil"))"
    }

    public var debugDescription: String {
        description
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
