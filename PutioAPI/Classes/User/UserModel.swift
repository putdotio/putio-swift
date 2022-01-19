import Foundation
import SwiftyJSON

open class PutioUser {
    open var id: Int
    open var username: String
    open var mail: String
    open var avatarURL: String
    open var hash: String
    open var features: [String: Any]
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
        open var disableSubtitles: Bool
        open var twoFactorEnabled: Bool

        init(json: JSON) {
            let routeName = json["tunnel_route_name"].stringValue
            self.sortBy = json["sort_by"].stringValue
            self.routeName = routeName == "" ? "default" : routeName
            self.suggestNextVideo = json["next_episode"].boolValue
            self.rememberVideoTime = json["start_from"].boolValue
            self.historyEnabled = json["history_enabled"].boolValue
            self.trashEnabled = json["trash_enabled"].boolValue
            self.showOptimisticUsage = json["show_optimistic_usage"].boolValue
            self.disableSubtitles = json["disable_subtitles"].boolValue
            self.twoFactorEnabled = json["two_factor_enabled"].boolValue
        }
    }

    open var settings: Settings

    init(json: JSON) {
        let info: JSON = json["info"]
        self.id = info["user_id"].intValue
        self.username = info["username"].string ?? info["mail"].stringValue
        self.mail = info["mail"].stringValue
        self.avatarURL = info["avatar_url"].stringValue
        self.hash = info["user_hash"].stringValue
        self.features = info["features"].dictionaryObject ?? [:]
        self.downloadToken = info["download_token"].stringValue
        self.trashSize = info["trash_size"].int64Value
        self.accountActive = info["account_active"].boolValue
        self.filesWillBeDeletedAt = info["files_will_be_deleted_at"].stringValue
        self.passwordLastChangedAt = info["password_last_changed_at"].stringValue
        self.disk = Disk(json: info["disk"])
        self.settings = Settings(json: info["settings"])
    }
}
