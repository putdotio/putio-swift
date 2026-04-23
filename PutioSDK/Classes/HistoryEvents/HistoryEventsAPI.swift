import Foundation
import SwiftyJSON

extension PutioSDK {
    public func getHistoryEvents() async throws -> [PutioHistoryEvent] {
        let envelope = try await request("/events/list", as: PutioHistoryEventsEnvelope.self)
        return envelope.events
    }

    public func getHistoryEvents(completion: @escaping (Result<[PutioHistoryEvent], PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getHistoryEvents()))
            } catch let error as PutioSDKError {
                return completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/events/list", method: .get)), unknownError: error)))
            }
        }
    }

    public func clearHistoryEvents() async throws -> PutioOKResponse {
        try await request("/events/delete", method: .post, as: PutioOKResponse.self)
    }

    public func clearHistoryEvents(completion: @escaping PutioSDKBoolCompletion) {
        Task {
            do {
                let response = try await clearHistoryEvents()
                let data = try JSONEncoder().encode(response)
                completion(.success(try JSON(data: data)))
            } catch let error as PutioSDKError {
                return completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/events/delete", method: .post)), unknownError: error)))
            }
        }
    }

    public func deleteHistoryEvent(eventID: Int) async throws -> PutioOKResponse {
        try await request("/events/delete/\(eventID)", method: .post, as: PutioOKResponse.self)
    }

    public func deleteHistoryEvent(eventID: Int, completion: @escaping PutioSDKBoolCompletion) {
        Task {
            do {
                let response = try await deleteHistoryEvent(eventID: eventID)
                let data = try JSONEncoder().encode(response)
                completion(.success(try JSON(data: data)))
            } catch let error as PutioSDKError {
                return completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/events/delete/\(eventID)", method: .post)), unknownError: error)))
            }
        }
    }
}

private struct PutioHistoryEventsEnvelope: Decodable {
    let events: [PutioHistoryEvent]

    enum CodingKeys: String, CodingKey {
        case events
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var eventsContainer = try container.nestedUnkeyedContainer(forKey: .events)
        var decodedEvents: [PutioHistoryEvent] = []

        while !eventsContainer.isAtEnd {
            let eventDecoder = try eventsContainer.superDecoder()
            let eventContainer = try eventDecoder.container(keyedBy: PutioHistoryEvent.CodingKeys.self)
            let rawType = try eventContainer.decodeIfPresent(String.self, forKey: .type) ?? ""
            decodedEvents.append(try PutioHistoryEventFactory.decode(rawType: rawType, from: eventDecoder))
        }

        self.events = decodedEvents
    }
}
