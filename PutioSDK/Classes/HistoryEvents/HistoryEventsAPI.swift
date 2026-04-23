import Foundation

extension PutioSDK {
    public func getHistoryEvents() async throws -> [PutioHistoryEvent] {
        let envelope = try await request("/events/list", as: PutioHistoryEventsEnvelope.self)
        return envelope.events
    }

    public func clearHistoryEvents() async throws -> PutioOKResponse {
        try await request("/events/delete", method: .post, as: PutioOKResponse.self)
    }

    public func deleteHistoryEvent(eventID: Int) async throws -> PutioOKResponse {
        try await request("/events/delete/\(eventID)", method: .post, as: PutioOKResponse.self)
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
