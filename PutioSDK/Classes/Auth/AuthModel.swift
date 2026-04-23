import Foundation

open class PutioTokenValidationResult: Decodable {
    open var result: Bool
    open var token_id: Int
    open var token_scope: String
    open var user_id: Int

    enum CodingKeys: String, CodingKey {
        case result
        case token_id
        case token_scope
        case user_id
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try container.decodeIfPresent(Bool.self, forKey: .result) ?? false
        self.token_id = try container.decodeIfPresent(Int.self, forKey: .token_id) ?? 0
        self.token_scope = try container.decodeIfPresent(String.self, forKey: .token_scope) ?? ""
        self.user_id = try container.decodeIfPresent(Int.self, forKey: .user_id) ?? 0
    }
}

open class PutioTwoFactorRecoveryCode: Decodable {
    open var code: String
    open var used_at: String?

    enum CodingKeys: String, CodingKey {
        case code
        case used_at
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.used_at = try container.decodeIfPresent(String.self, forKey: .used_at)
    }
}

open class PutioTwoFactorRecoveryCodes: Decodable {
    open var created_at: String
    open var codes: [PutioTwoFactorRecoveryCode]

    enum CodingKeys: String, CodingKey {
        case created_at
        case codes
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.created_at = try container.decodeIfPresent(String.self, forKey: .created_at) ?? ""
        self.codes = try container.decodeIfPresent([PutioTwoFactorRecoveryCode].self, forKey: .codes) ?? []
    }
}

open class PutioGenerateTOTPResult: Decodable {
    open var secret: String
    open var uri: String
    open var recovery_codes: PutioTwoFactorRecoveryCodes

    enum CodingKeys: String, CodingKey {
        case secret
        case uri
        case recovery_codes
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.secret = try container.decodeIfPresent(String.self, forKey: .secret) ?? ""
        self.uri = try container.decodeIfPresent(String.self, forKey: .uri) ?? ""
        self.recovery_codes = try container.decode(PutioTwoFactorRecoveryCodes.self, forKey: .recovery_codes)
    }
}

open class PutioVerifyTOTPResult: Decodable {
    open var token: String
    open var user_id: Int

    enum CodingKeys: String, CodingKey {
        case token
        case user_id
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decodeIfPresent(String.self, forKey: .token) ?? ""
        self.user_id = try container.decodeIfPresent(Int.self, forKey: .user_id) ?? 0
    }
}
