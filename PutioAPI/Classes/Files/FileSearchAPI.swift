import Foundation

extension PutioAPI {
    public func searchFiles(keyword: String, perPage: Int = 50, completion: @escaping (Result<PutioFileSearchResponse, PutioAPIError>) -> Void) {
        let URL = "/files/search"
        let query = ["query": keyword, "per_page": perPage] as [String : Any]

        self.get(URL)
            .query(query)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioFileSearchResponse(json: json)))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func continueFileSearch(cursor: String, completion: @escaping (Result<PutioFileSearchResponse, PutioAPIError>) -> Void) {
        let URL = "/files/search/continue"
        let query = ["cursor": cursor]

        self.get(URL)
            .query(query)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioFileSearchResponse(json: json)))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }
}
