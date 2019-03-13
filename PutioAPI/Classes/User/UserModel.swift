//
//  UserModel.swift
//  Putio
//
//  Created by Altay Aydemir on 7.11.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct PutioUser {
    let id: Int
    let username: String
    let mail: String
    let hash: String
    let features: [String: Any]

    var downloadToken: String

    public struct Disk {
        var available: Int64
        var availableReable: String
        var size: Int64
        var sizeReadable: String

        init(available: Int64, size: Int64) {
            self.available = available
            self.availableReable = available.bytesToHumanReadable()
            self.size = size
            self.sizeReadable = size.bytesToHumanReadable()
        }
    }

    var disk: Disk

    public struct Settings {
        var routeName: String
        var suggestNextVideo: Bool
        var rememberVideoTime: Bool
        var historyEnabled: Bool
        var trashEnabled: Bool
        var sortBy: String

        init(json: JSON) {
            self.routeName = json["tunnel_route_name"].stringValue
            self.suggestNextVideo = json["next_episode"].boolValue
            self.rememberVideoTime = json["start_from"].boolValue
            self.historyEnabled = json["history_enabled"].boolValue
            self.trashEnabled = json["trash_enabled"].boolValue
            self.sortBy = json["sort_by"].stringValue
        }
    }

    var settings: Settings

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
