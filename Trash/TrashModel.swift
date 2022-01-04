import Foundation
import SwiftyJSON

open class PutioTrashFile: PutioBaseFile {
    open var deletedAt: Date
    open var expiresAt: Date

    override init(json: JSON) {
        // Put.io API currently does not provide dates compatible with iso8601 but may support in the future
        let formatter = ISO8601DateFormatter()

        self.deletedAt = formatter.date(from: json["deleted_at"].stringValue) ??
            formatter.date(from: "\(json["deleted_at"].stringValue)+00:00")!

        self.expiresAt = formatter.date(from: json["expiration_date"].stringValue) ??
            formatter.date(from: "\(json["expiration_date"].stringValue)+00:00")!

        super.init(json: json)
    }
}


open class PutioListTrashResponse {
    open var cursor: String
    open var trash_size: Int64
    open var files: [PutioTrashFile]

    init(json: JSON) {
        self.cursor = json["cursor"].stringValue
        self.trash_size = json["trash_size"].int64Value
        self.files = json["files"].arrayValue.map { PutioTrashFile(json: $0) }
    }
}
