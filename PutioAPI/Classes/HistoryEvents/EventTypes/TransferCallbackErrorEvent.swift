//
//  TransferCallbackErrorEvent.swift
//  PutioAPI
//
//  Created by Batuhan Aksoy on 14.09.2020.
//

import SwiftyJSON

open class PutioTransferCallbackErrorEvent: PutioHistoryEvent {
    open var transferID: Int
    open var transferName: String
    open var message: String
    
    override init(json: JSON) {
        self.transferID = json["transfer_id"].intValue
        self.transferName = json["transfer_name"].stringValue
        self.message = json["message"].stringValue
        
        super.init(json: json)
        
        self.type = .transferCallbackError
    }
}
