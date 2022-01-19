import Foundation
import SwiftyJSON


public protocol PutioFileHistoryEvent {
    var fileID: Int { get set }
}

open class PutioHistoryEvent {
    public enum EventType {
        case upload, fileShared, transferCompleted, transferError, fileFromRSSDeletedError, rssFilterPaused, transferFromRSSError, transferCallbackError, privateTorrentPin, voucher, zipCreated, other
    }

    open var id: Int
    open var userID: Int
    open var type: EventType
    open var createdAt: Date

    init(json: JSON) {
        self.id = json["id"].intValue
        self.userID = json["user_id"].intValue

        self.type = .other

        // Put.io API currently does not provide dates compatible with iso8601, but can do in the future.
        let formatter = ISO8601DateFormatter()
        self.createdAt = formatter.date(from: json["created_at"].stringValue) ?? formatter.date(from: "\(json["created_at"].stringValue)+00:00")!
    }
}
