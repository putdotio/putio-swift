import Foundation

extension PutioSDK {
    public func searchFiles(keyword: String, perPage: Int = 50) async throws -> PutioFileSearchResponse {
        try await request("/files/search", query: ["query": keyword, "per_page": perPage], as: PutioFileSearchResponse.self)
    }

    public func searchFiles(keyword: String, perPage: Int = 50, completion: @escaping (Result<PutioFileSearchResponse, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await searchFiles(keyword: keyword, perPage: perPage)))
            } catch let error as PutioSDKError {
                return completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/files/search", method: .get, query: ["query": keyword, "per_page": perPage])), unknownError: error)))
            }
        }
    }

    public func continueFileSearch(cursor: String) async throws -> PutioFileSearchResponse {
        try await request("/files/search/continue", query: ["cursor": cursor], as: PutioFileSearchResponse.self)
    }

    public func continueFileSearch(cursor: String, completion: @escaping (Result<PutioFileSearchResponse, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await continueFileSearch(cursor: cursor)))
            } catch let error as PutioSDKError {
                return completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/files/search/continue", method: .get, query: ["cursor": cursor])), unknownError: error)))
            }
        }
    }
}
