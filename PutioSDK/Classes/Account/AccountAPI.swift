import Foundation
import Alamofire

extension PutioSDK {
    public func getAccountInfo(query: Parameters = [:]) async throws -> PutioAccount {
        let envelope = try await request("/account/info", query: query, as: PutioAccountInfoEnvelope.self)
        return envelope.info
    }

    public func getAccountInfo(query: Parameters = [:], completion: @escaping (Result<PutioAccount, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getAccountInfo(query: query)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/account/info", method: .get, query: query)), unknownError: error)))
            }
        }
    }

    public func getAccountSettings() async throws -> PutioAccount.Settings {
        let envelope = try await request("/account/settings", query: [:], as: PutioAccountSettingsEnvelope.self)
        return envelope.settings
    }

    public func getAccountSettings(completion: @escaping (Result<PutioAccount.Settings, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getAccountSettings()))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/account/settings", method: .get)), unknownError: error)))
            }
        }
    }

    public func saveAccountSettings(body: [String: Any], completion: @escaping PutioSDKBoolCompletion) {
        self.post("/account/settings", body: body) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func clearAccountData(options: [String: Bool], completion: @escaping PutioSDKBoolCompletion) {
        self.post("/account/clear", body: options) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func destroyAccount(currentPassword: String, completion: @escaping PutioSDKBoolCompletion) {
        self.post("/account/destroy", body: ["current_password": currentPassword]) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}

private struct PutioAccountInfoEnvelope: Decodable {
    let info: PutioAccount
}

private struct PutioAccountSettingsEnvelope: Decodable {
    let settings: PutioAccount.Settings
}
