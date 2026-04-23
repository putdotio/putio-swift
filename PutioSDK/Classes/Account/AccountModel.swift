import Foundation

open class PutioAccount: Decodable {
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

    public class Disk: Decodable {
        open var available: Int64
        open var size: Int64
        open var used: Int64

        enum CodingKeys: String, CodingKey {
            case available = "avail"
            case size
            case used
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.available = try container.decode(Int64.self, forKey: .available)
            self.size = try container.decode(Int64.self, forKey: .size)
            self.used = try container.decode(Int64.self, forKey: .used)
        }
    }

    open var disk: Disk

    public class Settings: Decodable {
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

        enum CodingKeys: String, CodingKey {
            case routeName = "tunnel_route_name"
            case suggestNextVideo = "next_episode"
            case rememberVideoTime = "start_from"
            case historyEnabled = "history_enabled"
            case trashEnabled = "trash_enabled"
            case sortBy = "sort_by"
            case showOptimisticUsage = "show_optimistic_usage"
            case twoFactorEnabled = "two_factor_enabled"
            case hideSubtitles = "hide_subtitles"
            case dontAutoSelectSubtitles = "dont_autoselect_subtitles"
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let routeName = try container.decodeIfPresent(String.self, forKey: .routeName) ?? ""
            self.routeName = routeName.isEmpty ? "default" : routeName
            self.suggestNextVideo = try container.decodeIfPresent(Bool.self, forKey: .suggestNextVideo) ?? false
            self.rememberVideoTime = try container.decodeIfPresent(Bool.self, forKey: .rememberVideoTime) ?? false
            self.historyEnabled = try container.decodeIfPresent(Bool.self, forKey: .historyEnabled) ?? false
            self.trashEnabled = try container.decodeIfPresent(Bool.self, forKey: .trashEnabled) ?? false
            self.sortBy = try container.decodeIfPresent(String.self, forKey: .sortBy) ?? ""
            self.showOptimisticUsage = try container.decodeIfPresent(Bool.self, forKey: .showOptimisticUsage) ?? false
            self.twoFactorEnabled = try container.decodeIfPresent(Bool.self, forKey: .twoFactorEnabled) ?? false
            self.hideSubtitles = try container.decodeIfPresent(Bool.self, forKey: .hideSubtitles) ?? false
            self.dontAutoSelectSubtitles = try container.decodeIfPresent(Bool.self, forKey: .dontAutoSelectSubtitles) ?? false
        }
    }

    open var settings: Settings

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case username
        case mail
        case avatarURL = "avatar_url"
        case hash = "user_hash"
        case features
        case downloadToken = "download_token"
        case trashSize = "trash_size"
        case accountActive = "account_active"
        case filesWillBeDeletedAt = "files_will_be_deleted_at"
        case passwordLastChangedAt = "password_last_changed_at"
        case disk
        case settings
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.mail = try container.decode(String.self, forKey: .mail)
        self.avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? ""
        self.hash = try container.decodeIfPresent(String.self, forKey: .hash) ?? ""
        self.features = try container.decodeIfPresent([String: Bool].self, forKey: .features) ?? [:]
        self.downloadToken = try container.decodeIfPresent(String.self, forKey: .downloadToken) ?? ""
        self.trashSize = try container.decodeIfPresent(Int64.self, forKey: .trashSize) ?? 0
        self.accountActive = try container.decodeIfPresent(Bool.self, forKey: .accountActive) ?? false
        self.filesWillBeDeletedAt = try container.decodeIfPresent(String.self, forKey: .filesWillBeDeletedAt) ?? ""
        self.passwordLastChangedAt = try container.decodeIfPresent(String.self, forKey: .passwordLastChangedAt) ?? ""
        self.disk = try container.decode(Disk.self, forKey: .disk)
        self.settings = try container.decode(Settings.self, forKey: .settings)
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
