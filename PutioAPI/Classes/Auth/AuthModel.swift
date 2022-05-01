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

open class PutioTwoFactorRecoveryCode {
    open var code: String
    open var used_at: String?

    init(json: JSON) {
        self.code = json["code"].stringValue
        self.used_at = json["used_at"].stringValue
    }
}

open class PutioTwoFactorRecoveryCodes {
    open var created_at: String
    open var codes: [PutioTwoFactorRecoveryCode]

    init(json: JSON) {
        self.created_at = json["created_at"].stringValue
        self.codes = json["codes"].arrayValue.map { PutioTwoFactorRecoveryCode(json: $0) }
    }
}

open class PutioGenerateTOTPResult {
    open var secret: String
    open var uri: String
    open var recovery_codes: PutioTwoFactorRecoveryCodes

    init(json: JSON) {
        self.secret = json["secret"].stringValue
        self.uri = json["uri"].stringValue
        self.recovery_codes = PutioTwoFactorRecoveryCodes(json: json["recovery_codes"])
    }
}

open class PutioVerifyTOTPResult {
    open var token: String
    open var user_id: Int

    init(json: JSON) {
        self.token = json["token"].stringValue
        self.user_id = json["user_id"].intValue
    }
}
