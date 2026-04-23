import Foundation

extension PutioSDK {
    public func getSubtitles(fileID: Int) async throws -> [PutioSubtitle] {
        let envelope = try await request("/files/\(fileID)/subtitles", query: ["oauth_token": self.config.token], as: PutioSubtitlesEnvelope.self)
        return envelope.subtitles
    }

    public func getSubtitles(fileID: Int, completion: @escaping (Result<[PutioSubtitle], PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getSubtitles(fileID: fileID)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/files/\(fileID)/subtitles", method: .get, query: ["oauth_token": self.config.token])), unknownError: error)))
            }
        }
    }
}

private struct PutioSubtitlesEnvelope: Decodable {
    let subtitles: [PutioSubtitle]
}
