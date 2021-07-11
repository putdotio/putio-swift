import Foundation
import SwiftyJSON

open class PutioFile {
    public enum FileType {
        case folder, video, audio, image, pdf, other
    }

    public struct VideoMetadata {
        public var height: Int
        public var width: Int
        public var codec: String
        public var duration: Double
        public var aspectRatio: Double

        init(json: JSON) {
            self.height = json["height"].intValue
            self.width = json["width"].intValue
            self.codec = json["codec"].stringValue
            self.duration = json["duration"].doubleValue
            self.aspectRatio = json["aspect_ratio"].doubleValue
        }
    }

    open var id: Int
    open var name: String
    open var icon: String
    open var type: FileType
    open var parentID: Int
    open var isShared: Bool

    open var size: Int64
    open var sizeReadable: String

    open var mp4Size: Int64
    open var mp4SizeReadable: String

    open var createdAt: Date
    open var createdAtRelative: String

    open var updatedAt: Date
    open var updatedAtRelative: String

    // MARK: Folder Properties
    open var isSharedRoot: Bool = false
    open var sortBy: String = ""

    // MARK: Video Properties
    open var needConvert: Bool = false
    open var hasMp4: Bool = false
    open var startFrom: Int = 0
    open var streamURL: String = ""
    open var mp4StreamURL: String = ""
    open var metaData: VideoMetadata?
    open var screenshot: String = ""

    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.icon = json["icon"].stringValue
        self.parentID = json["parent_id"].intValue
        self.isShared = json["is_shared"].boolValue

        // Eg: 1024.0
        self.size = json["size"].int64Value
        self.mp4Size = json["mp4_size"].int64Value

        // Eg: 1 MB
        self.sizeReadable = size.bytesToHumanReadable()
        self.mp4SizeReadable = mp4Size.bytesToHumanReadable()

        // Put.io API currently does not provide dates compatible with iso8601 but may support in the future
        let formatter = ISO8601DateFormatter()
        self.createdAt = formatter.date(from: json["created_at"].stringValue) ?? formatter.date(from: "\(json["created_at"].stringValue)+00:00")!

        // Eg: 5 Days Ago
        self.createdAtRelative = createdAt.timeAgoSinceDate()

        self.updatedAt = self.id == 0 ?
            self.createdAt :
            formatter.date(from: json["updated_at"].stringValue) ?? formatter.date(from: "\(json["updated_at"].stringValue)+00:00")!

        self.updatedAtRelative = updatedAt.timeAgoSinceDate()

        switch json["file_type"].stringValue {
        case "FOLDER":
            self.type = .folder
        case "VIDEO":
            self.type = .video
        case "AUDIO":
            self.type = .audio
        case "IMAGE":
            self.type = .image
        case "PDF":
            self.type = .pdf
        default:
            self.type = .other
        }

        if type == .folder {
            self.sortBy = json["sort_by"].stringValue
            self.isSharedRoot = json["folder_type"].stringValue == "SHARED_ROOT"
        }

        if type == .video {
            self.hasMp4 = json["is_mp4_available"].boolValue
            self.needConvert = json["need_convert"].boolValue
            self.streamURL = json["stream_url"].stringValue
            self.mp4StreamURL = json["mp4_stream_url"].stringValue
            self.screenshot = json["screenshot"].stringValue

            if json["video_metadata"].dictionary != nil {
                self.metaData = VideoMetadata(json: json["video_metadata"])
            }
        }

        if type == .audio || type == .video {
            self.startFrom = json["start_from"].intValue
        }
    }

    public func getStreamURL(token: String) -> URL? {
        switch (self.type) {
        case .audio:
            let url = "\(PutioAPI.apiURL)/files/\(self.id)/stream?oauth_token=\(token)"
            return URL(string: url)!
        case .video:
            let url = "\(PutioAPI.apiURL)/files/\(self.id)/hls/media.m3u8?subtitle_key=all&oauth_token=\(token)"
            return URL(string: url)!
        default:
            return nil
        }
    }

    public func getHlsStreamURL(token: String) -> URL {
        let url = "\(PutioAPI.apiURL)/files/\(self.id)/hls/media.m3u8?subtitle_key=all&oauth_token=\(token)"
        return URL(string: url)!
    }

    public func getAudioStreamURL(token: String) -> URL {
        let url = "\(PutioAPI.apiURL)/files/\(self.id)/stream?oauth_token=\(token)"
        return URL(string: url)!
    }

    public func getDownloadURL(token: String) -> URL {
        let url = "\(PutioAPI.apiURL)/files/\(self.id)/download?oauth_token=\(token)"
        return URL(string: url)!
    }

    public func getMp4DownloadURL(token: String) -> URL {
        let url = "\(PutioAPI.apiURL)/files/\(self.id)/mp4/download?oauth_token=\(token)"
        return URL(string: url)!
    }
}

public enum PutioNextFileType: String {
    case video = "VIDEO", audio = "AUDIO"
}

open class PutioNextFile {
    open var id: Int
    open var name: String
    open var parentID: Int
    open var type: PutioNextFileType

    init(json: JSON, type: PutioNextFileType) {
        self.id = json["id"].intValue
        self.parentID = json["parent_id"].intValue
        self.name = json["name"].stringValue
        self.type = type
    }

    public func getStreamURL(token: String) -> URL {
        switch (self.type) {
        case .audio:
            let url = "\(PutioAPI.apiURL)/files/\(self.id)/stream?oauth_token=\(token)"
            return URL(string: url)!
        case .video:
            let url = "\(PutioAPI.apiURL)/files/\(self.id)/hls/media.m3u8?subtitle_key=all&oauth_token=\(token)"
            return URL(string: url)!
        }
    }
}
