//
//  PutioKitTypes.swift
//  Putio
//
//  Created by Altay Aydemir on 11.11.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias Query = Parameters
typealias PutioKitBoolCompletion = ((_ success: Bool, _ error: Error?) -> Void)?

struct PutioKitConfig {
    var token: String
    var clientID: String
    var clientSecret: String
    var baseURL: String

    init(clientID: String, clientSecret: String, token: String = "") {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.token = token
        self.baseURL = PutioKit.apiURL
    }
}

struct PutioKitRequestInfo {
    let url: String
    let method: String
    let headers: Parameters
    let parameters: Parameters?
}

struct PutioKitError {
    let id: String
    let status: String
    let type: String
    let uri: String
    let statusCode: Int
    let message: String

    let ns: NSError

    init(_ requestInfo: PutioKitRequestInfo, _ json: JSON) {
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
