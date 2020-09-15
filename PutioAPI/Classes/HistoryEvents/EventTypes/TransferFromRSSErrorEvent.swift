//
//  TransferFromRSSErrorEvent.swift
//  PutioAPI
//
//  Created by Batuhan Aksoy on 14.09.2020.
//

import SwiftyJSON

open class PutioTransferFromRSSErrorEvent: PutioHistoryEvent {
    open var rssID: Int
    open var transferName: String
    
    override init(json: JSON) {
        self.rssID = json["rss_id"].intValue
        self.transferName = json["transfer_name"].stringValue
        
        super.init(json: json)
        
        self.type = .transferFromRSSError
    }
}
