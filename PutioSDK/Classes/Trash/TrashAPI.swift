import Foundation
import Alamofire

extension PutioSDK {
    public func listTrash(perPage: Int = 50) async throws -> PutioListTrashResponse {
        try await request("/trash/list", query: ["per_page": perPage], as: PutioListTrashResponse.self)
    }

    public func continueListTrash(cursor: String, perPage: Int = 50) async throws -> PutioListTrashResponse {
        try await request(
            "/trash/list/continue",
            method: .post,
            query: ["per_page": perPage],
            body: ["cursor": cursor],
            as: PutioListTrashResponse.self
        )
    }

    public func restoreTrashFiles(fileIDs: [Int] = [], cursor: String?) async throws -> PutioOKResponse {
        let body = putioTrashMutationBody(fileIDs: fileIDs, cursor: cursor)
        return try await request("/trash/restore", method: .post, body: body, as: PutioOKResponse.self)
    }

    public func deleteTrashFiles(fileIDs: [Int] = [], cursor: String?) async throws -> PutioOKResponse {
        let body = putioTrashMutationBody(fileIDs: fileIDs, cursor: cursor)
        return try await request("/trash/delete", method: .post, body: body, as: PutioOKResponse.self)
    }

    public func emptyTrash() async throws -> PutioOKResponse {
        try await request("/trash/empty", method: .post, as: PutioOKResponse.self)
    }
}

private func putioTrashMutationBody(fileIDs: [Int], cursor: String?) -> Parameters {
    if let cursor, !cursor.isEmpty {
        return ["cursor": cursor]
    }

    return ["file_ids": (fileIDs.map { String($0) }).joined(separator: ",")]
}
