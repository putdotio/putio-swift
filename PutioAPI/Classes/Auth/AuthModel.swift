import Foundation
import SwiftyJSON

open class PutioTokenValidationResult {
    open var result: Bool
    open var token_id: Int
    open var token_scope: String
    open var user_id: Int

    init(json: JSON) {
        self.result = json["result"].boolValue
        self.token_id = json["token_id"].intValue
        self.token_scope = json["token_scope"].stringValue
        self.user_id = json["user_id"].intValue
    }
}
