import Foundation
import Alamofire

extension PutioAPI {
    public func login(username: String, password: String, completion: @escaping (Result<String, PutioAPIError>) -> Void) {
        let headers = HTTPHeaders([HTTPHeader.authorization(username: username, password: password)])
        let query = [
            "client_secret": self.config.clientSecret,
            "client_name": self.config.clientName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        ]

        self.put("/oauth2/authorizations/clients/\(self.config.clientID)", headers: headers, query: query) { result in
            switch result {
            case .success(let json):
                return completion(.success(json["access_token"].stringValue))

            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

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

    public func getAuthCode(completion: @escaping (Result<String, PutioAPIError>) -> Void) {
        let query = [
            "app_id": self.config.clientID,
            "client_name": self.config.clientName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        ]

        self.get("/oauth2/oob/code", query: query) { result in
            switch result {
            case .success(let json):
                return completion(.success(json["code"].stringValue))

            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func checkAuthCodeMatch(code: String, completion: @escaping (Result<String, PutioAPIError>) -> Void) {
        self.get("/oauth2/oob/code/\(code)") { result in
            switch result {
            case .success(let json):
                return completion(.success(json["oauth_token"].stringValue))

            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func validateToken(token: String, completion: @escaping (Result<PutioTokenValidationResult, PutioAPIError>) -> Void) {
        self.get("/oauth2/validate") { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioTokenValidationResult(json: json)))

            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func logout(completion: @escaping PutioAPIBoolCompletion) {
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
    public func generateTOTP(completion: @escaping (Result<PutioGenerateTOTPResult, PutioAPIError>) -> Void) {
        self.post("/two_factor/generate/totp") { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioGenerateTOTPResult(json: json)))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func verifyTOTP(code: String, completion: @escaping (Result<PutioVerifyTOTPResult, PutioAPIError>) -> Void) {
        self.post("/two_factor/verify/totp", body: ["code": code]) { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioVerifyTOTPResult(json: json)))

            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func getRecoveryCodes(completion: @escaping (Result<PutioTwoFactorRecoveryCodes, PutioAPIError>) -> Void) {
        self.get("/two_factor/recovery_codes") { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioTwoFactorRecoveryCodes(json: json["recovery_codes"])))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func regenerateRecoveryCodes(completion: @escaping (Result<PutioTwoFactorRecoveryCodes, PutioAPIError>) -> Void) {
        self.post("/two_factor/recovery_codes/refresh") { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioTwoFactorRecoveryCodes(json: json["recovery_codes"])))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
