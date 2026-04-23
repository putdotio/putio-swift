import Foundation

open class PutioFileSearchResponse: Decodable {
    open var cursor: String
    open var files: [PutioFile]

    enum CodingKeys: String, CodingKey {
        case cursor
        case files
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cursor = try container.decodeIfPresent(String.self, forKey: .cursor) ?? ""
        self.files = try container.decodeIfPresent([PutioFile].self, forKey: .files) ?? []
    }
}
