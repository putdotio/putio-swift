import Foundation
import SwiftyJSON

extension PutioSDK {
    public func getGrants() async throws -> [PutioOAuthGrant] {
        let envelope = try await request("/oauth/grants", as: PutioGrantsEnvelope.self)
        return envelope.apps
    }

    public func getGrants(completion: @escaping (Result<[PutioOAuthGrant], PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getGrants()))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/oauth/grants", method: .get)), unknownError: error)))
            }
        }
    }

    public func revokeGrant(id: Int) async throws -> PutioOKResponse {
        try await request("/oauth/grants/\(id)/delete", method: .post, as: PutioOKResponse.self)
    }

    public func revokeGrant(id: Int, completion: @escaping PutioSDKBoolCompletion) {
        Task {
            do {
                let response = try await revokeGrant(id: id)
                let data = try JSONEncoder().encode(response)
                completion(.success(try JSON(data: data)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/oauth/grants/\(id)/delete", method: .post)), unknownError: error)))
            }
        }
    }

    public func linkDevice(code: String) async throws -> PutioOAuthGrant {
        let envelope = try await request("/oauth2/oob/code", method: .post, body: ["code": code], as: PutioGrantEnvelope.self)
        return envelope.app
    }

    public func linkDevice(code: String, completion: @escaping (Result<PutioOAuthGrant, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await linkDevice(code: code)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/oauth2/oob/code", method: .post, body: ["code": code])), unknownError: error)))
            }
        }
    }
}

private struct PutioGrantsEnvelope: Decodable {
    let apps: [PutioOAuthGrant]
}

private struct PutioGrantEnvelope: Decodable {
    let app: PutioOAuthGrant
}
