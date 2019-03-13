//
//  UserModel.swift
//  Putio
//
//  Created by Altay Aydemir on 7.11.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import SwiftyJSON

open class PutioUser {
    open var id: Int
    open var username: String
    open var mail: String
    open var hash: String
    open var features: [String: Any]
    open var downloadToken: String

    public class Disk {
        open var available: Int64
        open var availableReable: String
        open var size: Int64
        open var sizeReadable: String

        init(available: Int64, size: Int64) {
            self.available = available
            self.availableReable = available.bytesToHumanReadable()
            self.size = size
            self.sizeReadable = size.bytesToHumanReadable()
        }
    }

    open var disk: Disk

    public class Settings {
        open var routeName: String
        open var suggestNextVideo: Bool
        open var rememberVideoTime: Bool
        open var historyEnabled: Bool
        open var trashEnabled: Bool
        open var sortBy: String

        init(json: JSON) {
            self.routeName = json["tunnel_route_name"].stringValue
            self.suggestNextVideo = json["next_episode"].boolValue
            self.rememberVideoTime = json["start_from"].boolValue
            self.historyEnabled = json["history_enabled"].boolValue
            self.trashEnabled = json["trash_enabled"].boolValue
            self.sortBy = json["sort_by"].stringValue
        }
    }

    open var settings: Settings

    init(json: JSON) {
        let info: JSON = json["info"]

        self.id = info["user_id"].intValue
        self.username = info["username"].string ?? info["mail"].stringValue
        self.mail = info["mail"].stringValue
        self.hash = info["user_hash"].stringValue
        self.features = info["features"].dictionaryObject ?? [:]

        self.downloadToken = info["download_token"].stringValue
        self.disk = Disk(available: info["disk"]["avail"].int64Value, size: info["disk"]["size"].int64Value)
        self.settings = Settings(json: info["settings"])
    }
}
