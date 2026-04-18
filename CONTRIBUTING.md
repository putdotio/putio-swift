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

This check installs the example workspace and builds the `PutioAPI` framework against `iphonesimulator`, which works more reliably on this machine than destination-based CocoaPods lint

## Development Notes

- Keep `README.md` consumer-facing and put contributor workflow here
- Keep the repo shape ready for the future `putio-sdk-swift` rename while preserving the current CocoaPods package name `PutioAPI`
- Keep podspec metadata, tags, and release docs aligned when publishing a new version
- Use `bundle exec pod lib lint PutioAPI.podspec --allow-warnings` as a manual publish-time check when you need full podspec validation and have a working iOS destination available
- Use the example app for lightweight runtime sanity checks when changing auth or request flow behavior
- Do not commit tokens, private API credentials, or release-only secrets

## Pull Requests

- Keep changes focused and explicit
- Add or update verification when behavior changes
- Update docs when setup, release, or package expectations change
- Prefer follow-up pull requests over mixing unrelated cleanup into the same branch
