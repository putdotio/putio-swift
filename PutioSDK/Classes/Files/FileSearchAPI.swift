import Foundation

extension PutioSDK {
    public func searchFiles(keyword: String, perPage: Int = 50) async throws -> PutioFileSearchResponse {
        try await request("/files/search", query: ["query": keyword, "per_page": perPage], as: PutioFileSearchResponse.self)
    }

    public func continueFileSearch(cursor: String) async throws -> PutioFileSearchResponse {
        try await request("/files/search/continue", query: ["cursor": cursor], as: PutioFileSearchResponse.self)
    }
}
