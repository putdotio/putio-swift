//
//  PutioAPITypes.swift
//  Putio
//
//  Created by Altay Aydemir on 11.11.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias PutioAPIQuery = Parameters
public typealias PutioAPIBoolCompletion = ((_ success: Bool, _ error: Error?) -> Void)?

public struct PutioAPIConfig {
    public var token: String
    public var clientID: String
    public var clientSecret: String
    public var baseURL: String

    init(clientID: String, clientSecret: String, token: String = "") {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.token = token
        self.baseURL = PutioAPI.apiURL
    }
}

public struct PutioAPIRequestInfo {
    let url: String
    let method: String
    let headers: Parameters
    let parameters: Parameters?
}

public struct PutioAPIError {
    public let id: String
    public let status: String
    public let type: String
    public let uri: String
    public let statusCode: Int
    public let message: String

    public let ns: NSError

    init(_ requestInfo: PutioAPIRequestInfo, _ json: JSON) {
        self.id = json["error_id"].stringValue
        self.status = json["status"].stringValue
        self.type = json["error_type"].stringValue
        self.uri = json["error_uri"].stringValue
        self.statusCode = json["status_code"].intValue
        self.message = json["error_message"].stringValue

        let domain = "[\(requestInfo.method): \(requestInfo.url)]"

        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString(message, comment: message),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(message, comment: message),
            "ErrorID": id,
            "Headers": JSON(requestInfo.headers),
            "Parameters": JSON(requestInfo.parameters ?? [:])
        ] as [String: Any]

        self.ns = NSError(domain: domain, code: statusCode, userInfo: userInfo)
    }
}
