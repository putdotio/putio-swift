import Foundation

extension PutioAPI {
    public func getSubtitles(fileID: Int, completion: @escaping (_ subtitles: [PutioSubtitle]?, _ error: PutioAPIError?) -> Void) {
        let URL = "/files/\(fileID)/subtitles"
        let query = ["oauth_token": self.config.token]

        self.get(URL)
            .query(query)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                let subtitles = response!["subtitles"].arrayValue.map {PutioSubtitle(json: $0)}

                return completion(subtitles, nil)
        }
    }
}
