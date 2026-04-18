// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "PutioSDK",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .macCatalyst(.v14),
    ],
    products: [
        .library(
            name: "PutioSDK",
            targets: ["PutioSDK"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.5.0"),
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
    ]
)
