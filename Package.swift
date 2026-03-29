// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "PutioAPI",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .macCatalyst(.v14),
    ],
    products: [
        .library(
            name: "PutioAPI",
            targets: ["PutioAPI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.5.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "PutioAPI",
            dependencies: [
                "Alamofire",
                "SwiftyJSON"
            ],
            path: "PutioAPI/Classes"
        )
    ]
)
