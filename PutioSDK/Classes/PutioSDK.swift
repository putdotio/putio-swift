import Foundation
import Alamofire
import SwiftyJSON

public protocol PutioSDKDelegate: AnyObject {
    func onPutioSDKError(error: PutioSDKError)
}

public final class PutioSDK {
    public typealias RequestCompletion = (Result<JSON, PutioSDKError>) -> Void

    weak var delegate: PutioSDKDelegate?
    let urlSession: URLSession
    let jsonDecoder: JSONDecoder
    let jsonEncoder: JSONEncoder

    static let apiURL = "https://api.put.io/v2"

    public var config: PutioSDKConfig

    public convenience init(config: PutioSDKConfig) {
        self.init(config: config, urlSession: .shared)
    }

    init(config: PutioSDKConfig, urlSession: URLSession) {
        self.urlSession = urlSession
        self.config = config
        self.jsonDecoder = JSONDecoder()
        self.jsonEncoder = JSONEncoder()
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

    func request<T: Decodable>(
        _ url: String,
        method: HTTPMethod = .get,
        headers: HTTPHeaders = [:],
        query: Parameters = [:],
        body: Parameters = [:],
        as type: T.Type
    ) async throws -> T {
        let requestConfig = PutioSDKRequestConfig(
            apiConfig: config,
            url: url,
            method: method,
            headers: headers,
            query: query,
            body: body
        )
        let data = try await execute(requestConfig: requestConfig)

        do {
            return try jsonDecoder.decode(type, from: data)
        } catch {
            let apiError = PutioSDKError(request: PutioSDKErrorRequestInformation(config: requestConfig), decodingError: error, responseBody: String(decoding: data, as: UTF8.self))
            delegate?.onPutioSDKError(error: apiError)
            throw apiError
        }
    }


    private func send(requestConfig: PutioSDKRequestConfig, _ completion: @escaping (Result<JSON, PutioSDKError>) -> Void) {
        Task {
            do {
                let data = try await execute(requestConfig: requestConfig)
                let json = try JSON(data: data)
                completion(.success(json))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                let apiError = PutioSDKError(request: PutioSDKErrorRequestInformation(config: requestConfig), unknownError: error)
                delegate?.onPutioSDKError(error: apiError)
                completion(.failure(apiError))
            }
        }
    }

    private func execute(requestConfig: PutioSDKRequestConfig) async throws -> Data {
        let requestInformation = PutioSDKErrorRequestInformation(config: requestConfig)
        let urlRequest = try buildURLRequest(from: requestConfig)

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await urlSession.data(for: urlRequest)
        } catch {
            let apiError = PutioSDKError(request: requestInformation, error: error)
            delegate?.onPutioSDKError(error: apiError)
            throw apiError
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            let apiError = PutioSDKError(request: requestInformation, unknownError: URLError(.badServerResponse))
            delegate?.onPutioSDKError(error: apiError)
            throw apiError
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let body = String(decoding: data, as: UTF8.self)
            let envelope = try? jsonDecoder.decode(PutioAPIErrorEnvelope.self, from: data)
            let message = envelope?.resolvedMessage ?? "put.io returned HTTP \(httpResponse.statusCode)"
            let apiError = PutioSDKError(
                request: requestInformation,
                statusCode: envelope?.statusCode ?? httpResponse.statusCode,
                errorType: envelope?.errorType,
                message: message,
                underlyingError: URLError(.badServerResponse),
                responseBody: body
            )
            delegate?.onPutioSDKError(error: apiError)
            throw apiError
        }

        return data
    }

    private func buildURLRequest(from requestConfig: PutioSDKRequestConfig) throws -> URLRequest {
        guard let url = URL(string: requestConfig.url) else {
            throw PutioSDKError(request: PutioSDKErrorRequestInformation(config: requestConfig), unknownError: URLError(.badURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = requestConfig.method.rawValue
        request.timeoutInterval = config.timeoutInterval

        for header in requestConfig.headers {
            request.setValue(header.value, forHTTPHeaderField: header.name)
        }

        if let body = requestConfig.body, !body.isEmpty {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}
