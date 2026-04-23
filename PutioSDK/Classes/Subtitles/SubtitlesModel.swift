import Foundation

open class PutioSubtitle: Decodable {
    open var key: String
    open var language: String
    open var languageCode: String
    open var name: String
    open var source: String
    open var url: String

    enum CodingKeys: String, CodingKey {
        case key
        case language
        case languageCode = "language_code"
        case name
        case source
        case url
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = try container.decodeIfPresent(String.self, forKey: .key) ?? ""
        self.language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        self.languageCode = try container.decodeIfPresent(String.self, forKey: .languageCode) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
}
