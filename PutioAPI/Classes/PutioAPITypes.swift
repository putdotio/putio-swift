import Foundation
import Alamofire
import SwiftyJSON

public typealias PutioAPIQuery = Parameters

public struct PutioAPIConfig {
    public var token: String
    public var clientID: String
    public var clientSecret: String
    public var clientName: String
    public var baseURL: String

    init(clientID: String, clientSecret: String = "", clientName: String = "", token: String = "") {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.clientName = clientName
        self.token = token
        self.baseURL = PutioAPI.apiURL
    }
}

public struct PutioAPIRequestInfo {
    let url: String
    let method: HTTPMethod
    let headers: HTTPHeaders
    let parameters: Parameters?
}

public struct PutioAPIError: Error {
    public let request: PutioAPIRequestInfo
    public let id: String
    public let type: String
    public let uri: String
    public let message: String
    public let statusCode: Int
    public let underlyingError: Error

    init(requestInfo: PutioAPIRequestInfo, errorJSON: JSON, error: AFError) {
        self.request = requestInfo
        self.id = errorJSON["error_id"].stringValue
        self.type = errorJSON["error_type"].stringValue
        self.uri = errorJSON["error_uri"].stringValue
        self.message = errorJSON["message"].stringValue
        self.statusCode = errorJSON["status_code"].intValue
        self.underlyingError = error
    }

    init(requestInfo: PutioAPIRequestInfo, error: AFError) {
        self.request = requestInfo
        self.id = ""
        self.type = "NETWORK_ERROR"
        self.uri = requestInfo.url
        self.message = error.localizedDescription
        self.statusCode = 0
        self.underlyingError = error
    }

    init(requestInfo: PutioAPIRequestInfo, error: Error) {
        self.request = requestInfo
        self.id = ""
        self.type = "UNKNOWN_ERROR"
        self.uri = requestInfo.url
        self.message = error.localizedDescription
        self.statusCode = -1
        self.underlyingError = error
    }
}

public typealias PutioAPIBoolCompletion = ((_ success: Bool, _ error: PutioAPIError?) -> Void)?
