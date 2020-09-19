//
//  UploadEvent.swift
//  PutioAPI
//
//  Created by Batuhan Aksoy on 14.09.2020.
//

import SwiftyJSON

open class PutioUploadEvent: PutioHistoryEvent, PutioFileHistoryEvent {
    open var fileName: String
    open var fileSize: Int64
    open var fileID: Int
    
    override init(json: JSON) {
        self.fileName = json["file_name"].stringValue
        self.fileSize = json["file_size"].int64Value
        self.fileID = json["file_id"].intValue
        
        super.init(json: json)
        
        self.type = .upload
    }
}
