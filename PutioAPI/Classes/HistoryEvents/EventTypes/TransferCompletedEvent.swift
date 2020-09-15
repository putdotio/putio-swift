//
//  TransferCompletedEvent.swift
//  PutioAPI
//
//  Created by Batuhan Aksoy on 14.09.2020.
//

import SwiftyJSON

open class PutioTransferCompletedEvent: PutioFileHistoryEvent {
    open var transferName: String
    open var transferSize: Int64
    open var source: String
    
    override init(json: JSON) {
        self.transferName = json["transfer_name"].stringValue
        self.transferSize = json["transfer_size"].int64Value
        self.source = json["source"].stringValue
        
        super.init(json: json)
        
        self.type = .transferCompleted
        self.fileID = json["file_id"].intValue
    }
}
