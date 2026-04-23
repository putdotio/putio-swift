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

    public func getAuthCode(completion: @escaping (Result<String, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getAuthCode()))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/oauth2/oob/code", method: .get)), unknownError: error)))
            }
        }
    }

    public func getAuthCode() async throws -> String {
        let query = [
            "app_id": self.config.clientID,
            "client_name": self.config.clientName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        ]

        let envelope = try await request("/oauth2/oob/code", query: query, as: PutioAuthCodeEnvelope.self)
        return envelope.code
    }

    public func checkAuthCodeMatch(code: String, completion: @escaping (Result<String, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await checkAuthCodeMatch(code: code)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/oauth2/oob/code/\(code)", method: .get)), unknownError: error)))
            }
        }
    }

    public func checkAuthCodeMatch(code: String) async throws -> String {
        let envelope = try await request("/oauth2/oob/code/\(code)", as: PutioOAuthTokenEnvelope.self)
        return envelope.oauth_token
    }

    public func validateToken(token: String, completion: @escaping (Result<PutioTokenValidationResult, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await validateToken(token: token)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/oauth2/validate", method: .get)), unknownError: error)))
            }
        }
    }

    public func validateToken(token: String) async throws -> PutioTokenValidationResult {
        try await request("/oauth2/validate", headers: ["Authorization": "Token \(token)"], as: PutioTokenValidationResult.self)
    }

    public func logout(completion: @escaping PutioSDKBoolCompletion) {
        self.post("/oauth/grants/logout") { result in
            switch result {
            case .success(let json):
                return completion(.success(json))

            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    // MARK: two-factor
    public func generateTOTP(completion: @escaping (Result<PutioGenerateTOTPResult, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await generateTOTP()))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/two_factor/generate/totp", method: .post)), unknownError: error)))
            }
        }
    }

    public func generateTOTP() async throws -> PutioGenerateTOTPResult {
        try await request("/two_factor/generate/totp", method: .post, as: PutioGenerateTOTPResult.self)
    }

    public func verifyTOTP(code: String, completion: @escaping (Result<PutioVerifyTOTPResult, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await verifyTOTP(code: code)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/two_factor/verify/totp", method: .post, body: ["code": code])), unknownError: error)))
            }
        }
    }

    public func verifyTOTP(code: String) async throws -> PutioVerifyTOTPResult {
        try await request("/two_factor/verify/totp", method: .post, body: ["code": code], as: PutioVerifyTOTPResult.self)
    }

    public func getRecoveryCodes(completion: @escaping (Result<PutioTwoFactorRecoveryCodes, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getRecoveryCodes()))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/two_factor/recovery_codes", method: .get)), unknownError: error)))
            }
        }
    }

    public func getRecoveryCodes() async throws -> PutioTwoFactorRecoveryCodes {
        let envelope = try await request("/two_factor/recovery_codes", as: PutioRecoveryCodesEnvelope.self)
        return envelope.recovery_codes
    }

    public func regenerateRecoveryCodes(completion: @escaping (Result<PutioTwoFactorRecoveryCodes, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await regenerateRecoveryCodes()))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/two_factor/recovery_codes/refresh", method: .post)), unknownError: error)))
            }
        }
    }

    public func regenerateRecoveryCodes() async throws -> PutioTwoFactorRecoveryCodes {
        let envelope = try await request("/two_factor/recovery_codes/refresh", method: .post, as: PutioRecoveryCodesEnvelope.self)
        return envelope.recovery_codes
    }
}

private struct PutioAuthCodeEnvelope: Decodable {
    let code: String
}

private struct PutioOAuthTokenEnvelope: Decodable {
    let oauth_token: String
}

private struct PutioRecoveryCodesEnvelope: Decodable {
    let recovery_codes: PutioTwoFactorRecoveryCodes
}
