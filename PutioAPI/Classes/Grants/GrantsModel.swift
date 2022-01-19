import Foundation
import SwiftyJSON

open class PutioOAuthGrant {
    open var id: Int
    open var name: String
    open var description: String
    open var website: URL?

    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
        self.website = json["website"].url
    }
}
