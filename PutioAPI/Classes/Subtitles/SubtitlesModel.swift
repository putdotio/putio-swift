import Foundation
import SwiftyJSON

open class PutioSubtitle {
    open var key: String
    open var language: String
    open var languageCode: String
    open var name: String
    open var source: String
    open var url: String

    init(json: JSON) {
        self.key = json["key"].stringValue
        self.language = json["language"].stringValue
        self.languageCode = json["language_code"].stringValue
        self.name = json["name"].stringValue
        self.source = json["source"].stringValue
        self.url = json["url"].stringValue
    }
}
