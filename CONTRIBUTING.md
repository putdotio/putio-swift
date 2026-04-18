# Contributing

Thanks for contributing to `putio-sdk-swift`.

## Setup

Install the Ruby version from `.ruby-version`, then bootstrap the repository:

```bash
make bootstrap
```

If you want to run the example app locally, install its CocoaPods workspace too:

```bash
make example-install
```

## Run Locally

Open the example workspace:

```bash
open Example/PutioAPI.xcworkspace
```

## Validation

Run the repo-local verification command before opening or updating a pull request:

```bash
make verify
```

This check builds the Swift package, installs the example workspace, and then builds the example-backed `PutioAPI` framework. It prefers any Xcode-advertised iPhone simulator destination on iOS `26.0+`, and falls back to the installed `iphonesimulator` SDK when Xcode is not exposing one yet

To see the concrete iPhone simulator destination Xcode is advertising to the repo on your machine, run:

```bash
make print-simulator-destination
```

## Development Notes

- Keep `README.md` consumer-facing and put contributor workflow here
- The GitHub repository is `putio-sdk-swift`
- The Swift Package product and module are `PutioSDK`
- The repository includes a `PutioSDK` CocoaPods podspec ready for automated publishing
- `PutioAPI` remains the currently published CocoaPods package until `PutioSDK` is released from CI
- The public SDK type names remain `PutioAPI`
- Keep `Package.swift`, `PutioSDK.podspec`, `PutioAPI.podspec`, and `VERSION` aligned when dependency or platform support changes
- Any iPhone simulator on iOS `26.0` or newer is acceptable for interactive example runs; the repo does not require an exact simulator patch version
- Use `bundle exec pod lib lint PutioSDK.podspec --allow-warnings` and `bundle exec pod lib lint PutioAPI.podspec --allow-warnings` as manual publish-time checks when you need full podspec validation and have a working iOS destination available
- Use the example app for lightweight runtime sanity checks when changing auth or request flow behavior
- Do not commit tokens, private API credentials, or release-only secrets
- The release workflow uses semantic-release on `master` and `main`
- GitHub releases only need the built-in `GITHUB_TOKEN`; CocoaPods publishing additionally needs `COCOAPODS_TRUNK_TOKEN`

## Pull Requests

- Keep changes focused and explicit
- Add or update verification when behavior changes
- Update docs when setup, release, or package expectations change
- Prefer follow-up pull requests over mixing unrelated cleanup into the same branch
