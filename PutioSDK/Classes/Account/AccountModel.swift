import Foundation
import SwiftyJSON

open class PutioAccount {
    open var id: Int
    open var username: String
    open var mail: String
    open var avatarURL: String
    open var hash: String
    open var features: [String: Bool]
    open var downloadToken: String
    open var trashSize: Int64
    open var accountActive: Bool
    open var filesWillBeDeletedAt: String
    open var passwordLastChangedAt: String

    public class Disk {
        open var available: Int64
        open var size: Int64
        open var used: Int64

        init(json: JSON) {
            self.available = json["avail"].int64Value
            self.size = json["size"].int64Value
            self.used = json["used"].int64Value
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
        open var showOptimisticUsage: Bool
        open var twoFactorEnabled: Bool
        open var hideSubtitles: Bool
        open var dontAutoSelectSubtitles: Bool

        init(json: JSON) {
            let routeName = json["tunnel_route_name"].stringValue
            self.sortBy = json["sort_by"].stringValue
            self.routeName = routeName == "" ? "default" : routeName
            self.suggestNextVideo = json["next_episode"].boolValue
            self.rememberVideoTime = json["start_from"].boolValue
            self.historyEnabled = json["history_enabled"].boolValue
            self.trashEnabled = json["trash_enabled"].boolValue
            self.showOptimisticUsage = json["show_optimistic_usage"].boolValue
            self.twoFactorEnabled = json["two_factor_enabled"].boolValue
            self.hideSubtitles = json["hide_subtitles"].boolValue
            self.dontAutoSelectSubtitles = json["dont_autoselect_subtitles"].boolValue
        }
    }

    open var settings: Settings

    init(json: JSON) {
        self.id = json["user_id"].intValue
        self.username = json["username"].stringValue
        self.mail = json["mail"].stringValue
        self.avatarURL = json["avatar_url"].stringValue
        self.hash = json["user_hash"].stringValue
        self.features = json["features"].dictionaryObject as? [String: Bool] ?? [:]
        self.downloadToken = json["download_token"].stringValue
        self.trashSize = json["trash_size"].int64Value
        self.accountActive = json["account_active"].boolValue
        self.filesWillBeDeletedAt = json["files_will_be_deleted_at"].stringValue
        self.passwordLastChangedAt = json["password_last_changed_at"].stringValue
        self.disk = Disk(json: json["disk"])
        self.settings = Settings(json: json["settings"])
    }
}

public var PutioClearDataOptionKeys = [
    "files",
    "finished_transfers",
    "active_transfers",
    "rss_feeds",
    "rss_logs",
    "history",
    "trash",
    "friends"
]
