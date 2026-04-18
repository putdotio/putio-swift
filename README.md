<div align="center">
  <p>
    <img src="https://static.put.io/images/putio-boncuk.png" width="72" alt="put.io boncuk">
  </p>

  <h1>putio-sdk-swift</h1>

  <p>
    Swift SDK for the <a href="https://api.put.io/v2/docs">put.io API</a>
  </p>

  <p>
    CocoaPods package: <code>PutioAPI</code>
  </p>

  <p>
    <a href="https://github.com/putdotio/putio-swift/actions/workflows/ci.yml?query=branch%3Amaster" style="text-decoration:none;"><img src="https://img.shields.io/github/actions/workflow/status/putdotio/putio-swift/ci.yml?branch=master&style=flat&label=ci&colorA=000000&colorB=000000" alt="CI"></a>
    <a href="https://cocoapods.org/pods/PutioAPI" style="text-decoration:none;"><img src="https://img.shields.io/cocoapods/v/PutioAPI?style=flat&colorA=000000&colorB=000000" alt="CocoaPods version"></a>
    <a href="https://github.com/putdotio/putio-swift/blob/master/LICENSE" style="text-decoration:none;"><img src="https://img.shields.io/github/license/putdotio/putio-swift?style=flat&colorA=000000&colorB=000000" alt="license"></a>
  </p>
</div>

`putio-sdk-swift` is the public-facing repo shape we want, while the package you install today is still named `PutioAPI`

## Installation

Install with CocoaPods:

```ruby
pod 'PutioAPI'
```

## Quick Start

```swift
import PutioAPI

let api = PutioAPI(
    config: PutioAPIConfig(
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

## Authentication Example

The example app shows a minimal `ASWebAuthenticationSession` flow and a follow-up account fetch:

- [Example/PutioAPI/ViewController.swift](./Example/PutioAPI/ViewController.swift)
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
