<div align="center">
  <p>
    <img src="https://static.put.io/images/putio-boncuk.png" width="72" alt="put.io boncuk">
  </p>

  <h1>putio-sdk-swift</h1>

  <p>
    Swift SDK for the <a href="https://api.put.io/v2/docs">put.io API</a>
  </p>

  <p>
    Swift Package: <code>PutioSDK</code> · CocoaPods package: <code>PutioSDK</code>
  </p>

  <p>
    <a href="https://github.com/putdotio/putio-sdk-swift/actions/workflows/ci.yml?query=branch%3Amain" style="text-decoration:none;"><img src="https://img.shields.io/github/actions/workflow/status/putdotio/putio-sdk-swift/ci.yml?branch=main&style=flat&label=ci&colorA=000000&colorB=000000" alt="CI"></a>
    <a href="https://cocoapods.org/pods/PutioSDK" style="text-decoration:none;"><img src="https://img.shields.io/cocoapods/v/PutioSDK?style=flat&colorA=000000&colorB=000000" alt="CocoaPods version"></a>
    <a href="https://github.com/putdotio/putio-sdk-swift/blob/main/LICENSE" style="text-decoration:none;"><img src="https://img.shields.io/github/license/putdotio/putio-sdk-swift?style=flat&colorA=000000&colorB=000000" alt="license"></a>
  </p>
</div>

## Installation

Install with Swift Package Manager in Xcode using:

```text
https://github.com/putdotio/putio-sdk-swift.git
```

Or add it to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/putdotio/putio-sdk-swift.git", from: "1.0.0")
]
```

Then depend on the `PutioSDK` product.

Import it as:

```swift
import PutioSDK
```

If you use CocoaPods today, install with:

```ruby
pod 'PutioSDK'
```

## Quick Start

```swift
import PutioSDK

let api = PutioSDK(
    config: PutioSDKConfig(
        clientID: "<your-client-id>",
        token: "<your-access-token>"
    )
)

api.getAccountInfo { result in
    switch result {
    case .success(let account):
        print(account.username)
    case .failure(let error):
        print(error.message)
    }
}
```

## Verification

The repo exposes one local verification command:

```bash
make verify
```

Use `make bootstrap` first on a fresh clone. `make verify` installs the example workspace, prefers any Xcode-advertised iPhone simulator destination on iOS `26.0+`, and falls back to the installed `iphonesimulator` SDK when Xcode is not exposing one yet

Releases are continuous on `main`: every merge is treated as releasable. Conventional commits drive version selection through semantic-release, GitHub releases run automatically after `make verify` passes, and CocoaPods publishing runs from the same workflow when `COCOAPODS_TRUNK_TOKEN` is configured

## Authentication Example

The example app shows a minimal `ASWebAuthenticationSession` flow and a follow-up account fetch:

- [Example/PutioSDK/ViewController.swift](./Example/PutioSDK/ViewController.swift)
- [Example/README.md](./Example/README.md)

## Docs

- [CONTRIBUTING.md](./CONTRIBUTING.md) for local setup and verification
- [SECURITY.md](./SECURITY.md) for private vulnerability reporting
- [AGENTS.md](./AGENTS.md) for repo-specific agent guidance
- [Example](./Example) for the example app and smoke-test workspace

## Contributing

Start with [CONTRIBUTING.md](./CONTRIBUTING.md) so local setup, verification, and release expectations stay aligned with CI

## License

This project is available under the [MIT License](./LICENSE)
