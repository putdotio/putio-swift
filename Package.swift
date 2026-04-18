// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "PutioSDK",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .macCatalyst(.v26),
    ],
    products: [
        .library(
            name: "PutioSDK",
            targets: ["PutioSDK"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.11.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "PutioSDK",
            dependencies: [
                "Alamofire",
                "SwiftyJSON",
            ],
            path: "PutioSDK/Classes"
        ),
    ],
    swiftLanguageModes: [
        .v5
    ]
)
