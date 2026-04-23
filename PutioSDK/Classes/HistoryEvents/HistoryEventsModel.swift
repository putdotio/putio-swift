import Foundation

public protocol PutioFileHistoryEvent {
    var fileID: Int { get set }
}

open class PutioHistoryEvent: Decodable {
    public enum EventType {
        case upload, fileShared, transferCompleted, transferError, fileFromRSSDeletedError, rssFilterPaused, transferFromRSSError, transferCallbackError, privateTorrentPin, voucher, zipCreated, other
    }

    open var id: Int
    open var userID: Int
    open var type: EventType
    open var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case type
        case createdAt = "created_at"
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.type = Self.eventType(from: try container.decodeIfPresent(String.self, forKey: .type) ?? "")
        self.createdAt = try PutioSDKDateParser.decodeDate(forKey: .createdAt, from: container)
    }

    static func eventType(from rawValue: String) -> EventType {
        switch rawValue.lowercased() {
        case "upload":
            return .upload
        case "file_shared":
            return .fileShared
        case "transfer_completed":
            return .transferCompleted
        case "transfer_error":
            return .transferError
        case "file_from_rss_deleted_for_space":
            return .fileFromRSSDeletedError
        case "rss_filter_paused":
            return .rssFilterPaused
        case "transfer_from_rss_error":
            return .transferFromRSSError
        case "transfer_callback_error":
            return .transferCallbackError
        case "private_torrent_pin":
            return .privateTorrentPin
        case "voucher":
            return .voucher
        case "zip_created":
            return .zipCreated
        default:
            return .other
        }
    }
}
