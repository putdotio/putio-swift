import Foundation

extension PutioAPI {
    public func searchFiles(keyword: String, perPage: Int = 50, completion: @escaping (_ result: PutioFileSearchResponse?, _ error: PutioAPIError?) -> Void) {
        let URL = "/files/search"
        let query = ["query": keyword, "per_page": perPage] as [String : Any]

        self.get(URL)
            .query(query)
            .end { (json, error) in
                guard let json = json, error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioFileSearchResponse(json: json), nil)
        }
    }

    public func continueFileSearch(cursor: String, completion: @escaping (_ result: PutioFileSearchResponse?, _ error: PutioAPIError?) -> Void) {
        let URL = "/files/search/continue"
        let query = ["cursor": cursor]

        self.get(URL)
            .query(query)
            .end { (json, error) in
                guard let json = json, error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioFileSearchResponse(json: json), nil)
        }
    }
}
