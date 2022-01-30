import Foundation

extension PutioAPI {
    public func getSubtitles(fileID: Int, completion: @escaping (Result<[PutioSubtitle], PutioAPIError>) -> Void) {
        let URL = "/files/\(fileID)/subtitles"
        let query = ["oauth_token": self.config.token]

        self.get(URL)
            .query(query)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json["subtitles"].arrayValue.map {PutioSubtitle(json: $0)}))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }
}
