//
//  PrivateTorrentPin.swift
//  PutioAPI
//
//  Created by Batuhan Aksoy on 14.09.2020.
//

import SwiftyJSON

open class PutioPrivateTorrentPinEvent: PutioHistoryEvent {
    open var userDownloadName: String
    open var pinnedHostIP: String
    open var newHostIP: String
    
    override init(json: JSON) {
        self.userDownloadName = json["user_download_name"].stringValue
        self.pinnedHostIP = json["pinned_host_ip"].stringValue
        self.newHostIP = json["new_host_ip"].stringValue
        
        super.init(json: json)
        
        self.type = .privateTorrentPin
    }
}
