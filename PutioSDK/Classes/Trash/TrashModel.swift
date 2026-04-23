import Foundation

open class PutioTrashFile: PutioBaseFile {
    open var deletedAt: Date
    open var expiresOn: Date

    enum CodingKeys: String, CodingKey {
        case deletedAt = "deleted_at"
        case expiresOn = "expiration_date"
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deletedAt = try PutioSDKDateParser.decodeDate(forKey: .deletedAt, from: container)
        self.expiresOn = try PutioSDKDateParser.decodeDate(forKey: .expiresOn, from: container)
        try super.init(from: decoder)
    }
}

open class PutioListTrashResponse: Decodable {
    open var cursor: String
    open var trash_size: Int64
    open var files: [PutioTrashFile]

    enum CodingKeys: String, CodingKey {
        case cursor
        case trash_size
        case files
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor) ?? ""
        self.trash_size = try container.decodeIfPresent(Int64.self, forKey: .trash_size) ?? 0
        self.files = try container.decodeIfPresent([PutioTrashFile].self, forKey: .files) ?? []
    }
}
