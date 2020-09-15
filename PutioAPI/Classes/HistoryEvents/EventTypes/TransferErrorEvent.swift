//
//  TransferErrorEvent.swift
//  PutioAPI
//
//  Created by Batuhan Aksoy on 14.09.2020.
//

//
//  UploadEvent.swift
//  PutioAPI
//
//  Created by Batuhan Aksoy on 14.09.2020.
//

import SwiftyJSON

open class PutioTransferErrorEvent: PutioHistoryEvent {
    open var source: String
    open var transferName: String
    
    override init(json: JSON) {
        self.source = json["source"].stringValue
        self.transferName = json["transfer_name"].stringValue
        
        super.init(json: json)
        
        self.type = .transferError
    }
}
