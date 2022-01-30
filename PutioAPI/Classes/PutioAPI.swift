import Foundation
import Alamofire
import SwiftyJSON

public protocol PutioAPIDelegate: class {
    func onPutioAPIApiError(error: PutioAPIError)
}

public final class PutioAPI {
    weak var delegate: PutioAPIDelegate?

    static let apiURL = "https://api.put.io/v2"
    static let webAppURL = "https://app.put.io"

    public var config: PutioAPIConfig
    
    private var requestURL: String
    private var method: HTTPMethod
    private var headers: HTTPHeaders
    private var parameters: Parameters?

    public init(clientID: String, clientSecret: String = "") {
        self.config = PutioAPIConfig(clientID: clientID, clientSecret: clientSecret)
        self.headers = [:]
        self.method = .get
        self.requestURL = self.config.baseURL
        self.parameters = nil
    }

    public func setToken(token: String) {
        self.config.token = token
    }

    public func clearToken() {
        self.config.token = ""
    }

    func reset() {
        self.requestURL = config.baseURL
        self.method = .get
        self.parameters = nil
        self.headers = [:]
    }

    func authenticate(username: String, password: String) -> PutioAPI {
        headers = [.authorization(username: username, password: password)]
        return self
    }

    func set(key: String, value: String) -> PutioAPI {
        headers[key] = value
        return self
    }

    func get(_ URL: String) -> PutioAPI {
        self.requestURL = "\(config.baseURL)\(URL)"
        self.method = .get
        return self
    }

    func post(_ URL: String) -> PutioAPI {
        self.requestURL = "\(config.baseURL)\(URL)"
        self.method = .post
        return self
    }

    func put(_ URL: String) -> PutioAPI {
        self.requestURL = "\(config.baseURL)\(URL)"
        self.method = .put
        return self
    }

    func delete(_ URL: String) -> PutioAPI {
        self.requestURL = "\(config.baseURL)\(URL)"
        self.method = .delete
        return self
    }

    func query(_ parameters: Parameters) -> PutioAPI {
        let url = URL(string: self.requestURL)!
        let urlRequest = URLRequest(url: url)
        let encodedURLRequest = try! URLEncoding.queryString.encode(urlRequest, with: parameters)
        self.requestURL = (encodedURLRequest.url?.absoluteString)!
        return self
    }

    func send(_ parameters: Parameters) -> PutioAPI {
        self.parameters = parameters
        return self
    }

    func end(_ completion: @escaping (JSON?, PutioAPIError?) -> Void) {
        if config.token != "" {
            headers["Authorization"] = "token \(config.token)"
        }

        let requestInfo = PutioAPIRequestInfo(
            url: self.requestURL,
            method: self.method,
            headers: self.headers,
            parameters: self.parameters
        )

        self.reset()

        AF
            .request(
                requestInfo.url,
                method: requestInfo.method,
                parameters: requestInfo.parameters,
                encoding: JSONEncoding.default,
                headers: requestInfo.headers
            ) { $0.timeoutInterval = 10 }
            .validate()
            .responseData(completionHandler: { dataResponse in
                do {
                    switch dataResponse.result {
                    case .success(let data):
                        let json = try JSON(data: data)
                        return completion(json, nil)

                    case .failure(let error):
                        if let data = dataResponse.data {
                            let apiError = PutioAPIError(requestInfo: requestInfo, errorJSON: try JSON(data: data), error: error)
                            self.delegate?.onPutioAPIApiError(error: apiError)
                            return completion(nil, apiError)
                        }

                        let apiError = PutioAPIError(requestInfo: requestInfo, error: error)
                        self.delegate?.onPutioAPIApiError(error: apiError)
                        return completion(nil, apiError)
                    }
                } catch {
                    let apiError = PutioAPIError(requestInfo: requestInfo, error: error)
                    self.delegate?.onPutioAPIApiError(error: apiError)
                    return completion(nil, apiError)
                }
            })
        }
}
