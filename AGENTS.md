# Agent Guide

## Repo

- Swift SDK for the put.io API
- Current distribution model: Swift Package plus CocoaPods podspec, with an example app workspace

## Start Here

- package overview: [README.md](./README.md)
- contributor workflow: [CONTRIBUTING.md](./CONTRIBUTING.md)
- security policy: [SECURITY.md](./SECURITY.md)

## Commands

- `make bootstrap`
- `make verify`
- `make example-install`
- `make print-simulator-destination`

## Repo-Specific Guidance

- Keep the public package surface open-source-safe
- Prefer the `make verify` entrypoint instead of ad hoc validation commands
- The GitHub repository is `putio-sdk-swift`
- The Swift Package surface is `PutioSDK`
- The repository includes a `PutioSDK` CocoaPods podspec ready for automated publishing
- `PutioAPI` remains the currently published CocoaPods package until `PutioSDK` is released from CI
- The existing public SDK type names remain `PutioAPI`
- CI and release automation run from `main`
- The release workflow uses semantic-release after `make verify` passes on `main`
- GitHub releases need only the built-in `GITHUB_TOKEN`; CocoaPods publishing additionally needs `COCOAPODS_TRUNK_TOKEN`
- Verify example workspace installation when auth-flow or package-install surface changes
- Repo verification should build the Swift package and the `PutioAPI` framework from the example workspace
- `make verify` prefers an Xcode-advertised iPhone simulator destination on iOS `26.0+` and falls back to the installed `iphonesimulator` SDK when Xcode is not exposing one yet
- `make print-simulator-destination` shows the concrete iPhone simulator destination the repo would use when Xcode can advertise one
- `pod lib lint` remains a manual publish-time check until destination resolution is consistent across local and CI environments
- Use the example app for auth-flow smoke checks when request behavior changes
- Update docs when package metadata, release flow, or verification changes
