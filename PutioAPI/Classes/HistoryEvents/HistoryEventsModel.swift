//
//  EventsModel.swift
//  Putio
//
//  Created by Altay Aydemir on 4.12.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import SwiftyJSON


open class PutioHistoryEvent {
    public enum EventType {
        case upload, fileShared, transferCompleted, transferError, fileFromRSSDeletedError, rssFilterPaused, transferFromRSSError, transferCallbackError, privateTorrentPin, voucherEvent, other
    }
    open var id: Int
    open var type: EventType

    open var createdAt: Date
    open var createdAtRelative: String

    open var userID: Int

    init(json: JSON) {
        self.id = json["id"].intValue
        self.userID = json["user_id"].intValue

        self.type = .other

        // Put.io API currently does not provide dates compatible with iso8601, but can do in the future.
        let formatter = ISO8601DateFormatter()
        self.createdAt = formatter.date(from: json["created_at"].stringValue) ?? formatter.date(from: "\(json["created_at"].stringValue)+00:00")!

        // Ex: 5 Days Ago
        self.createdAtRelative = createdAt.timeAgoSinceDate()
    }
}
