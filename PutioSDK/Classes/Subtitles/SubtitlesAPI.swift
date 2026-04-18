import Foundation

extension PutioSDK {
    public func getSubtitles(fileID: Int, completion: @escaping (Result<[PutioSubtitle], PutioSDKError>) -> Void) {
        self.get("/files/\(fileID)/subtitles", query: ["oauth_token": self.config.token]) { result in
            switch result {
            case .success(let json):
                return completion(.success(json["subtitles"].arrayValue.map {PutioSubtitle(json: $0)}))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
