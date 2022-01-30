import Foundation
import Alamofire
import SwiftyJSON

public typealias PutioAPIQuery = Parameters

public struct PutioAPIConfig {
    public var baseURL: String
    public var token: String
    public var clientID: String
    public var clientSecret: String
    public var clientName: String
    public var timeoutInterval: Double

    public init(clientID: String, clientSecret: String = "", clientName: String = "", token: String = "", timeoutInterval: Double = 10.0) {
        self.baseURL = PutioAPI.apiURL
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.clientName = clientName
        self.token = token
        self.timeoutInterval = timeoutInterval
    }
}

public struct PutioAPIRequestInfo {
    let url: String
    let method: HTTPMethod
    let headers: HTTPHeaders
    let parameters: Parameters?
}

public enum PutioAPIErrorType {
    case httpError(statusCode: Int, errorType: String)
    case networkError
    case unknownError
}

public struct PutioAPIError: Error {
    public let requestInfo: PutioAPIRequestInfo
    public let type: PutioAPIErrorType
    public let message: String
    public let underlyingError: Error

    init(requestInfo: PutioAPIRequestInfo, errorJSON: JSON, error: AFError) {
        self.requestInfo = requestInfo
        self.type = .httpError(statusCode: errorJSON["status_code"].intValue, errorType: errorJSON["error_type"].stringValue)
        self.message = errorJSON["message"].stringValue
        self.underlyingError = error
    }

    init(requestInfo: PutioAPIRequestInfo, error: AFError) {
        self.requestInfo = requestInfo
        self.type = .networkError
        self.message = error.localizedDescription
        self.underlyingError = error
    }

    init(requestInfo: PutioAPIRequestInfo, error: Error) {
        self.requestInfo = requestInfo
        self.type = .unknownError
        self.message = error.localizedDescription
        self.underlyingError = error
    }
}

public typealias PutioAPIBoolCompletion = (Result<JSON, PutioAPIError>) -> Void
