//
//  PutioAPI.swift
//  Putio
//
//  Created by Altay Aydemir on 26.10.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public protocol PutioAPIDelegate: class {
    func onPutioAPIApiError(error: Error)
    func onPutioAPIParseError(error: Error)
}

public final class PutioAPI {
    weak var delegate: PutioAPIDelegate?
    static let apiURL = "https://api.put.io/v2"

    var config: PutioAPIConfig
    var headers: HTTPHeaders
    var method: HTTPMethod
    var parameters: Parameters?
    var requestURL: String

    public init(clientID: String, clientSecret: String) {
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
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }

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

    func end(_ completion: @escaping (JSON?, Error?) -> Void) {
        if config.token != "" {
            headers["Authorization"] = "token \(config.token)"
        }

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        Alamofire
            .request(
                self.requestURL,
                method: self.method,
                parameters: self.parameters,
                encoding: JSONEncoding.default,
                headers: self.headers
            )
            .validate()
            .responseJSON { (response) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

                switch response.result {
                case .success:
                    let json = try! JSON(data: response.data!)
                    return completion(json, nil)
                case .failure(let responseError):
                    do {
                        let json = try JSON(data: response.data!)
                        let requestInfo = PutioAPIRequestInfo(
                            url: self.requestURL,
                            method: self.method.rawValue,
                            headers: self.headers,
                            parameters: self.parameters ?? nil
                        )
                        let error = PutioAPIError(requestInfo, json).ns
                        self.delegate?.onPutioAPIApiError(error: error)
                        return completion(nil, error)
                    } catch {
                        self.delegate?.onPutioAPIApiError(error: responseError)
                        self.delegate?.onPutioAPIParseError(error: error)
                        return completion(nil, responseError)
                    }
                }
        }
    }
}
