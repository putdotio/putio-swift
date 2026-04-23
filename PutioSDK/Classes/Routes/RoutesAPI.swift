import Foundation

extension PutioSDK {
    public func getRoutes() async throws -> [PutioRoute] {
        let envelope = try await request("/tunnel/routes", as: PutioRoutesEnvelope.self)
        return envelope.routes
    }

    public func getRoutes(completion: @escaping (Result<[PutioRoute], PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getRoutes()))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/tunnel/routes", method: .get)), unknownError: error)))
            }
        }
    }
}

private struct PutioRoutesEnvelope: Decodable {
    let routes: [PutioRoute]
}
