import Foundation

extension PutioAPI {
    public func getLoginURL(redirectURI: String, responseType: String = "token", state: String = "") -> URL {
        var url = URLComponents(string: "\(PutioAPI.webAppURL)/authenticate")

        url?.queryItems = [
            URLQueryItem(name: "client_id", value: self.config.clientID),
            URLQueryItem(name: "client_name", value: self.config.clientName),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: responseType),
            URLQueryItem(name: "state", value: state),
        ]

        return (url?.url!)!
    }

    public func login(username: String, password: String, clientName: String, completion: @escaping (Result<String, PutioAPIError>) -> Void) {
        let clientName = clientName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let URL = "/oauth2/authorizations/clients/\(self.config.clientID)?client_secret=\(self.config.clientSecret)&client_name=\(clientName!)"

        self.authenticate(username: username, password: password)
            .put(URL)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json["access_token"].stringValue))

                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func getAuthCode(clientName: String, completion: @escaping (Result<String, PutioAPIError>) -> Void) {
        let clientName = clientName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let URL = "/oauth2/oob/code?app_id=\(self.config.clientID)&client_name=\(clientName!)"

        self.get(URL)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json["code"].stringValue))

                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func checkAuthCodeMatch(code: String, completion: @escaping (Result<String, PutioAPIError>) -> Void) {
        let URL = "/oauth2/oob/code/\(code)"

        self.get(URL)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json["oauth_token"].stringValue))

                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func validateToken(token: String, completion: @escaping (Result<PutioTokenValidationResult, PutioAPIError>) -> Void) {
        let URL = "/oauth2/validate"

        self.get(URL)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioTokenValidationResult(json: json)))

                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func verifyTOTP(totp: String, completion: @escaping (Result<PutioVerifyTOTPResult, PutioAPIError>) -> Void) {
        let URL = "/two_factor/verify/totp"
        let body = ["totp": totp] as [String: String]

        self.post(URL)
            .send(body)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioVerifyTOTPResult(json: json)))

                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func logout(completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/oauth/grants/logout"

        self.post(URL)
            .end { result in
                switch result {
                case .success(let json):
                    return completion(.success(json))

                case .failure(let error):
                    return completion(.failure(error))
                }
            }
    }
}
