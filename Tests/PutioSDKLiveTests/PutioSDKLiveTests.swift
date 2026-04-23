import XCTest

@testable import PutioSDK

final class PutioSDKLiveTests: XCTestCase {
    func testAccountInfoLoadsAgainstRealAPI() async throws {
        let sdk = try LiveSupport.newAuthedClient()
        let account = try await sdk.getAccountInfo()

        XCTAssertFalse(account.username.isEmpty)
        XCTAssertGreaterThan(account.id, 0)
    }

    func testFilesAndTrashDisposableFlow() async throws {
        let sdk = try LiveSupport.newAuthedClient()
        let folderName = LiveSupport.uniqueName(prefix: "putio-swift-live")

        let created = try await sdk.createFolder(name: folderName, parentID: 0)
        let createdID = created.id
        XCTAssertGreaterThan(createdID, 0)

        do {
            let listing = try await sdk.getFiles(parentID: 0)
            XCTAssertTrue(listing.children.contains(where: { $0.id == createdID }))

            _ = try await sdk.deleteFiles(fileIDs: [createdID])

            let trash = try await sdk.listTrash()
            XCTAssertTrue(trash.files.contains(where: { $0.id == createdID }))

            _ = try await sdk.restoreTrashFiles(fileIDs: [createdID], cursor: nil)

            let restored = try await sdk.getFile(fileID: createdID)
            XCTAssertEqual(restored.id, createdID)
        } catch {
            try await cleanup(sdk: sdk, fileID: createdID)
            throw error
        }

        try await cleanup(sdk: sdk, fileID: createdID)
    }

    private func cleanup(sdk: PutioSDK, fileID: Int) async throws {
        _ = try? await sdk.deleteFiles(fileIDs: [fileID])
        _ = try? await sdk.deleteTrashFiles(fileIDs: [fileID], cursor: nil)
    }
}
