//
//  FileSharedEvent.swift
//  AcknowList
//
//  Created by Batuhan Aksoy on 14.09.2020.
//

import SwiftyJSON

open class PutioFileSharedEvent: PutioFileHistoryEvent {
    open var sharingUserName: String
    open var fileName: String
    open var fileSize: Int64
    
    override init(json: JSON) {
        self.sharingUserName = json["sharing_user_name"].stringValue
        self.fileName = json["file_name"].stringValue
        self.fileSize = json["file_size"].int64Value
        
        super.init(json: json)
        
        self.type = .fileShared
        self.fileID = json["file_id"].intValue
    }
}
