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

let sdk = PutioSDK(
    config: PutioSDKConfig(
        clientID: "<your-client-id>",
        token: "<your-access-token>"
    )
)

Task {
    do {
        let account = try await sdk.getAccountInfo()
        print(account.username)
    } catch let error as PutioSDKError {
        print(error.message)
        print(error.recoverySuggestion ?? "")
    }
}
```

The SDK exposes an async-first `async throws` surface with native `URLSession` transport and no third-party networking dependency. It no longer ships completion-handler compatibility wrappers or raw JSON response APIs.

## Verification

The repo exposes one local verification command:

```bash
make verify
```

Use `make bootstrap` first on a fresh clone. `make verify` runs SwiftPM tests with coverage enabled, enforces a `90%` source line coverage floor for `PutioSDK/Classes`, installs the example workspace, prefers any Xcode-advertised iPhone simulator destination on iOS `26.0+`, and falls back to the installed `iphonesimulator` SDK when Xcode is not exposing one yet

An opt-in live verification lane is also available:

```bash
make live-test
```

Releases are continuous on `main`: every merge is treated as releasable. Conventional commits drive version selection through semantic-release, GitHub releases run automatically after `make verify` passes, and CocoaPods publishing runs from the same workflow when `COCOAPODS_TRUNK_TOKEN` is configured

## Authentication Example

The example app shows a minimal `ASWebAuthenticationSession` flow and a follow-up account fetch:

- [Example/PutioSDK/ViewController.swift](./Example/PutioSDK/ViewController.swift)
- [Example app guide](./Example/README.md)

## Docs

- [Example app](./Example) for the example app and smoke-test workspace
- [Architecture](./docs/ARCHITECTURE.md) for the current async transport and decoding direction
- [Testing](./docs/TESTING.md) for deterministic and live verification
- [Readiness](./docs/READINESS.md) for the current verification confidence
- [Security](./SECURITY.md) for private vulnerability reporting

## Repo Internals

- [Agent guide](./AGENTS.md) for repo-specific agent guidance

## Contributing

Start with [Contributing](./CONTRIBUTING.md) so local setup, verification, and release expectations stay aligned with CI

## License

This project is available under the [MIT License](./LICENSE)
