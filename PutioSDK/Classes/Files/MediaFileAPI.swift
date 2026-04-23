import Foundation
import SwiftyJSON

extension PutioSDK {
    public func startMp4Conversion(fileID: Int) async throws -> PutioOKResponse {
        try await request("/files/\(fileID)/mp4", method: .post, as: PutioOKResponse.self)
    }

    public func startMp4Conversion(fileID: Int, completion: @escaping PutioSDKBoolCompletion) {
        Task {
            do {
                let response = try await startMp4Conversion(fileID: fileID)
                let data = try JSONEncoder().encode(response)
                completion(.success(try JSON(data: data)))
            } catch let error as PutioSDKError {
                return completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/files/\(fileID)/mp4", method: .post)), unknownError: error)))
            }
        }
    }

    public func getMp4ConversionStatus(fileID: Int) async throws -> PutioMp4Conversion {
        let envelope = try await request("/files/\(fileID)/mp4", as: PutioMp4ConversionEnvelope.self)
        return envelope.mp4
    }

    public func getMp4ConversionStatus(fileID: Int, completion: @escaping (Result<PutioMp4Conversion, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getMp4ConversionStatus(fileID: fileID)))
            } catch let error as PutioSDKError {
                return completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/files/\(fileID)/mp4", method: .get)), unknownError: error)))
            }
        }
    }

    public func getStartFrom(fileID: Int) async throws -> Int {
        let response = try await request("/files/\(fileID)/start-from", as: PutioStartFromResponse.self)
        return response.startFrom
    }

    public func getStartFrom(fileID: Int, completion: @escaping (Result<Int, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getStartFrom(fileID: fileID)))
            } catch let error as PutioSDKError {
                return completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/files/\(fileID)/start-from", method: .get)), unknownError: error)))
            }
        }
    }

    public func setStartFrom(fileID: Int, time: Int) async throws -> PutioOKResponse {
        try await request("/files/\(fileID)/start-from/set", method: .post, body: ["time": time], as: PutioOKResponse.self)
    }

    public func setStartFrom(fileID: Int, time: Int, completion: @escaping PutioSDKBoolCompletion) {
        Task {
            do {
                let response = try await setStartFrom(fileID: fileID, time: time)
                let data = try JSONEncoder().encode(response)
                completion(.success(try JSON(data: data)))
            } catch let error as PutioSDKError {
                return completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/files/\(fileID)/start-from/set", method: .post, body: ["time": time])), unknownError: error)))
            }
        }
    }

    public func resetStartFrom(fileID: Int) async throws -> PutioOKResponse {
        try await request("/files/\(fileID)/start-from/delete", as: PutioOKResponse.self)
    }

    public func resetStartFrom(fileID: Int, completion: @escaping PutioSDKBoolCompletion) {
        Task {
            do {
                let response = try await resetStartFrom(fileID: fileID)
                let data = try JSONEncoder().encode(response)
                completion(.success(try JSON(data: data)))
            } catch let error as PutioSDKError {
                return completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/files/\(fileID)/start-from/delete", method: .get)), unknownError: error)))
            }
        }
    }
}

private struct PutioMp4ConversionEnvelope: Decodable {
    let mp4: PutioMp4Conversion
}
