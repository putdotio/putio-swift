//
//  FileFromRSSDeletedErrorEvent.swift
//  PutioAPI
//
//  Created by Batuhan Aksoy on 14.09.2020.
//

import SwiftyJSON

open class PutioFileFromRSSDeletedErrorEvent: PutioHistoryEvent {
    open var fileName: String
    open var fileSource: String
    open var fileSize: Int64
    
    override init(json: JSON) {
        self.fileName = json["file_name"].stringValue
        self.fileSource = json["file_source"].stringValue
        self.fileSize = json["file_size"].int64Value
        
        super.init(json: json)
        
        self.type = .fileFromRSSDeletedError
    }
}
