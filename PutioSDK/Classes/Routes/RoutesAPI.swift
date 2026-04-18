import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getRoutes(completion: @escaping (Result<[PutioRoute], PutioAPIError>) -> Void) {
        self.get("/tunnel/routes") { result in
            switch result {
            case .success(let json):
                return completion(.success(json["routes"].arrayValue.map { PutioRoute(json: $0) }))
            case .failure(let error):
                return completion(.failure(error))

            }
        }
    }
}
