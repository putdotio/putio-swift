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

public struct PutioFileSearchQuery {
    public let keyword: String
    public let perPage: Int?
    public let types: [PutioFileType]

    public init(keyword: String, perPage: Int? = 50, types: [PutioFileType] = []) {
        self.keyword = keyword
        self.perPage = perPage
        self.types = types
    }

    var parameters: [String: Any] {
        var query: [String: Any] = ["query": keyword]
        if let perPage {
            query["per_page"] = perPage
        }
        if !types.isEmpty {
            query["type"] = types.map(\.rawValue).joined(separator: ",")
        }
        return query
    }
}

public struct PutioFileSearchContinueQuery {
    public let perPage: Int?

    public init(perPage: Int? = nil) {
        self.perPage = perPage
    }

    var parameters: [String: Any] {
        var query: [String: Any] = [:]
        if let perPage {
            query["per_page"] = perPage
        }
        return query
    }
}
