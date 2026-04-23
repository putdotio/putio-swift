import Foundation
import Alamofire

extension PutioSDK {
    public func getAuthURL(redirectURI: String, responseType: String = "token", state: String = "") -> URL {
        var url = URLComponents(string: "\(self.config.baseURL)/oauth2/authenticate")

        url?.queryItems = [
            URLQueryItem(name: "client_id", value: self.config.clientID),
            URLQueryItem(name: "client_name", value: self.config.clientName),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: responseType),
            URLQueryItem(name: "state", value: state),
        ]

        return (url?.url!)!
    }

    public func getAuthCode() async throws -> PutioAuthCode {
        let query = [
            "app_id": self.config.clientID,
            "client_name": self.config.clientName
        ]

        return try await request(
            "/oauth2/oob/code",
            headers: ["Authorization": ""],
            query: query,
            as: PutioAuthCode.self
        )
    }

    public func checkAuthCodeMatch(code: String) async throws -> String? {
        let envelope = try await request(
            "/oauth2/oob/code/\(code)",
            headers: ["Authorization": ""],
            as: PutioOAuthTokenEnvelope.self
        )
        return envelope.oauth_token
    }

    public func validateToken(token: String) async throws -> PutioTokenValidationResult {
        try await request("/oauth2/validate", headers: ["Authorization": "Token \(token)"], as: PutioTokenValidationResult.self)
    }

    public func logout() async throws -> PutioOKResponse {
        try await request("/oauth/grants/logout", method: .post, as: PutioOKResponse.self)
    }

    // MARK: two-factor
    public func generateTOTP() async throws -> PutioGenerateTOTPResult {
        try await request("/two_factor/generate/totp", method: .post, as: PutioGenerateTOTPResult.self)
    }
    public func verifyTOTP(twoFactorScopedToken: String, code: String) async throws -> PutioVerifyTOTPResult {
        try await request(
            "/two_factor/verify/totp",
            method: .post,
            headers: ["Authorization": ""],
            query: ["oauth_token": twoFactorScopedToken],
            body: ["code": code],
            as: PutioVerifyTOTPResult.self
        )
    }
    public func getRecoveryCodes() async throws -> PutioTwoFactorRecoveryCodes {
        let envelope = try await request("/two_factor/recovery_codes", as: PutioRecoveryCodesEnvelope.self)
        return envelope.recovery_codes
    }
    public func regenerateRecoveryCodes() async throws -> PutioTwoFactorRecoveryCodes {
        let envelope = try await request("/two_factor/recovery_codes/refresh", method: .post, as: PutioRecoveryCodesEnvelope.self)
        return envelope.recovery_codes
    }
}

private struct PutioOAuthTokenEnvelope: Decodable {
    let oauth_token: String?
}

private struct PutioRecoveryCodesEnvelope: Decodable {
    let recovery_codes: PutioTwoFactorRecoveryCodes
}
