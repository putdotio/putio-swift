# Agent Guide

## Repo

- Swift SDK for the put.io API
- Current distribution model: CocoaPods podspec plus example app workspace

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
- Keep the repo ready for a future `putio-sdk-swift` rename while preserving the current `PutioAPI` CocoaPods package surface
- CI currently accepts both `master` and `main` pushes so branch migration can happen without breaking guardrails
- Verify example workspace installation when auth-flow or package-install surface changes
- Repo verification should build the `PutioAPI` framework from the example workspace
- `make verify` prefers an Xcode-advertised iPhone simulator destination on iOS `26.0+` and falls back to the installed `iphonesimulator` SDK when Xcode is not exposing one yet
- `make print-simulator-destination` shows the concrete iPhone simulator destination the repo would use when Xcode can advertise one
- `pod lib lint` remains a manual publish-time check until destination resolution is consistent across local and CI environments
- Use the example app for auth-flow smoke checks when request behavior changes
- Update docs when package metadata, release flow, or verification changes
