import Foundation
import SwiftyJSON

public enum PutioFileType {
    case folder, video, audio, image, pdf, other
}

open class PutioBaseFile {
    open var id: Int
    open var name: String
    open var icon: String
    open var type: PutioFileType
    open var parentID: Int
    open var size: Int64
    open var createdAt: Date

    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.icon = json["icon"].stringValue
        self.parentID = json["parent_id"].intValue

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

        // Eg: 1024.0
        self.size = json["size"].int64Value

        // Put.io API currently does not provide dates compatible with iso8601 but may support in the future
        let formatter = ISO8601DateFormatter()
        self.createdAt = formatter.date(from: json["created_at"].stringValue) ?? formatter.date(from: "\(json["created_at"].stringValue)+00:00")!
    }
}

public struct PutioVideoMetadata {
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

open class PutioFile: PutioBaseFile {
    open var isShared: Bool
    open var updatedAt: Date

    // MARK: Folder Properties
    open var isSharedRoot: Bool = false
    open var sortBy: String = ""

    // MARK: Video Properties
    open var metaData: PutioVideoMetadata?
    open var screenshot: String = ""
    open var startFrom: Int = 0

    open var needConvert: Bool = false
    open var hasMp4: Bool = false

    open var mp4Size: Int64 = 0
    open var mp4StreamURL: String = ""

    open var streamURL: String = ""

    override init(json: JSON) {
        let base = PutioBaseFile(json: json)

        self.isShared = json["is_shared"].boolValue

        // Put.io API currently does not provide dates compatible with iso8601 but may support in the future
        let formatter = ISO8601DateFormatter()
        self.updatedAt = base.id == 0 ? base.createdAt :
            formatter.date(from: json["updated_at"].stringValue) ??
            formatter.date(from: "\(json["updated_at"].stringValue)+00:00")!

        if base.type == .folder {
            self.sortBy = json["sort_by"].stringValue
            self.isSharedRoot = json["folder_type"].stringValue == "SHARED_ROOT"
        }

        if base.type == .video {
            self.hasMp4 = json["is_mp4_available"].boolValue
            self.needConvert = json["need_convert"].boolValue
            self.streamURL = json["stream_url"].stringValue
            self.mp4StreamURL = json["mp4_stream_url"].stringValue
            self.screenshot = json["screenshot"].stringValue

            if (self.hasMp4) {
                self.mp4Size = json["mp4_size"].int64Value
            }

            if json["video_metadata"].dictionary != nil {
                self.metaData = PutioVideoMetadata(json: json["video_metadata"])
            }
        }

        if base.type == .audio || base.type == .video {
            self.startFrom = json["start_from"].intValue
        }

        super.init(json: json)
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
