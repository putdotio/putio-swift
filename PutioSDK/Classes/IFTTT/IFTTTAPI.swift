import Foundation

extension PutioSDK {
    public func sendIFTTTEvent(event: PutioIFTTTEvent) async throws -> PutioOKResponse {
        try await request(
            "/ifttt-client/event",
            method: .post,
            body: ["event_type": event.eventType, "ingredients": event.ingredients.toJSON()],
            as: PutioOKResponse.self
        )
    }
}
