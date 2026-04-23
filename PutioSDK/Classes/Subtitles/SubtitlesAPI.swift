import Foundation

extension PutioSDK {
    public func getSubtitles(fileID: Int) async throws -> [PutioSubtitle] {
        let envelope = try await request("/files/\(fileID)/subtitles", query: ["oauth_token": self.config.token], as: PutioSubtitlesEnvelope.self)
        return envelope.subtitles
    }
}

private struct PutioSubtitlesEnvelope: Decodable {
    let subtitles: [PutioSubtitle]
}
