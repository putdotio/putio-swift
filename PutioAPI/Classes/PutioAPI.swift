import Foundation
import Alamofire
import SwiftyJSON

public protocol PutioAPIDelegate: class {
    func onPutioAPIApiError(error: PutioAPIError)
}

public final class PutioAPI {
    typealias RequestCompletion = (Result<JSON, PutioAPIError>) -> Void

    weak var delegate: PutioAPIDelegate?

    static let apiURL = "https://api.put.io/v2"

    public var config: PutioAPIConfig

    public init(config: PutioAPIConfig) {
        self.config = config
    }

    public func setToken(token: String) {
        self.config.token = token
    }

    public func clearToken() {
        self.config.token = ""
    }

    func get(_ url: String, headers: HTTPHeaders = [:], query: Parameters = [:], _ completion: @escaping RequestCompletion) {
        let requestConfig = PutioAPIRequestConfig(apiConfig: config, url: url, method: .get, headers: headers, query: query)
        self.send(requestConfig: requestConfig, completion)
    }

    func post(_ url: String, headers: HTTPHeaders = [:], query: Parameters = [:], body: Parameters = [:], _ completion: @escaping RequestCompletion) {
        let requestConfig = PutioAPIRequestConfig(apiConfig: config, url: url, method: .post, headers: headers, query: query, body: body)
        self.send(requestConfig: requestConfig, completion)
    }

    func put(_ url: String, headers: HTTPHeaders = [:], query: Parameters = [:], body: Parameters = [:], _ completion: @escaping RequestCompletion) {
        let requestConfig = PutioAPIRequestConfig(apiConfig: config, url: url, method: .put, headers: headers, query: query, body: body)
        self.send(requestConfig: requestConfig, completion)
    }

    func delete(_ url: String, headers: HTTPHeaders = [:], query: Parameters = [:], _ completion: @escaping RequestCompletion) {
        let requestConfig = PutioAPIRequestConfig(apiConfig: config, url: url, method: .delete, headers: headers, query: query)
        self.send(requestConfig: requestConfig, completion)
    }


    private func send(requestConfig: PutioAPIRequestConfig, _ completion: @escaping (Result<JSON, PutioAPIError>) -> Void) {
        let requestInformation = PutiopAPIErrorRequestInformation(config: requestConfig)

        AF.request(
            requestConfig.url,
            method: requestConfig.method,
            parameters: requestConfig.body,
            encoding: JSONEncoding.default,
            headers: requestConfig.headers
        ) { $0.timeoutInterval = self.config.timeoutInterval }
        .validate()
        .responseData(completionHandler: { dataResponse in
            do {
                switch dataResponse.result {
                case .success(let data):
                    let json = try JSON(data: data)
                    return completion(.success(json))

                case .failure(let error):
                    if let data = dataResponse.data {
                        let apiError = PutioAPIError(request: requestInformation, errorJSON: try JSON(data: data), error: error)
                        self.delegate?.onPutioAPIApiError(error: apiError)
                        return completion(.failure(apiError))
                    }

                    let apiError = PutioAPIError(request: requestInformation, error: error)
                    self.delegate?.onPutioAPIApiError(error: apiError)
                    return completion(.failure(apiError))
                }
            } catch {
                let apiError = PutioAPIError(request: requestInformation, error: error)
                self.delegate?.onPutioAPIApiError(error: apiError)
                return completion(.failure(apiError))
            }
        })
    }
}
