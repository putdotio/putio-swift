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

This check installs the example workspace, prefers any Xcode-advertised iPhone simulator destination on iOS `26.0+`, and falls back to the installed `iphonesimulator` SDK when Xcode is not exposing one yet

To see the concrete iPhone simulator destination Xcode is advertising to the repo on your machine, run:

```bash
make print-simulator-destination
```

## Development Notes

- Keep `README.md` consumer-facing and put contributor workflow here
- The GitHub repository is `putio-sdk-swift` while the CocoaPods package name remains `PutioAPI`
- Keep podspec metadata, tags, and release docs aligned when publishing a new version
- Any iPhone simulator on iOS `26.0` or newer is acceptable for interactive example runs; the repo does not require an exact simulator patch version
- Use `bundle exec pod lib lint PutioAPI.podspec --allow-warnings` as a manual publish-time check when you need full podspec validation and have a working iOS destination available
- Use the example app for lightweight runtime sanity checks when changing auth or request flow behavior
- Do not commit tokens, private API credentials, or release-only secrets

## Pull Requests

- Keep changes focused and explicit
- Add or update verification when behavior changes
- Update docs when setup, release, or package expectations change
- Prefer follow-up pull requests over mixing unrelated cleanup into the same branch
