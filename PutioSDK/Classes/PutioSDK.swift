import Foundation
import Alamofire
import SwiftyJSON

public protocol PutioSDKDelegate: AnyObject {
    func onPutioSDKError(error: PutioSDKError)
}

public final class PutioSDK {
    public typealias RequestCompletion = (Result<JSON, PutioSDKError>) -> Void

    weak var delegate: PutioSDKDelegate?

    static let apiURL = "https://api.put.io/v2"

    public var config: PutioSDKConfig

    public init(config: PutioSDKConfig) {
        self.config = config
    }

    public func setToken(token: String) {
        self.config.token = token
    }

    public func clearToken() {
        self.config.token = ""
    }

    public func get(_ url: String, headers: HTTPHeaders = [:], query: Parameters = [:], _ completion: @escaping RequestCompletion) {
        let requestConfig = PutioSDKRequestConfig(apiConfig: config, url: url, method: .get, headers: headers, query: query)
        self.send(requestConfig: requestConfig, completion)
    }

    public func post(_ url: String, headers: HTTPHeaders = [:], query: Parameters = [:], body: Parameters = [:], _ completion: @escaping RequestCompletion) {
        let requestConfig = PutioSDKRequestConfig(apiConfig: config, url: url, method: .post, headers: headers, query: query, body: body)
        self.send(requestConfig: requestConfig, completion)
    }

    public func put(_ url: String, headers: HTTPHeaders = [:], query: Parameters = [:], body: Parameters = [:], _ completion: @escaping RequestCompletion) {
        let requestConfig = PutioSDKRequestConfig(apiConfig: config, url: url, method: .put, headers: headers, query: query, body: body)
        self.send(requestConfig: requestConfig, completion)
    }

    public func delete(_ url: String, headers: HTTPHeaders = [:], query: Parameters = [:], _ completion: @escaping RequestCompletion) {
        let requestConfig = PutioSDKRequestConfig(apiConfig: config, url: url, method: .delete, headers: headers, query: query)
        self.send(requestConfig: requestConfig, completion)
    }


    private func send(requestConfig: PutioSDKRequestConfig, _ completion: @escaping (Result<JSON, PutioSDKError>) -> Void) {
        let requestInformation = PutioSDKErrorRequestInformation(config: requestConfig)

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
                        let apiError = PutioSDKError(request: requestInformation, errorJSON: try JSON(data: data), error: error)
                        self.delegate?.onPutioSDKError(error: apiError)
                        return completion(.failure(apiError))
                    }

                    let apiError = PutioSDKError(request: requestInformation, error: error)
                    self.delegate?.onPutioSDKError(error: apiError)
                    return completion(.failure(apiError))
                }
            } catch {
                let apiError = PutioSDKError(request: requestInformation, error: error)
                self.delegate?.onPutioSDKError(error: apiError)
                return completion(.failure(apiError))
            }
        })
    }
}
