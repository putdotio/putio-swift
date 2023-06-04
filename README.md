<div align="center">
  <p>
    <img src="https://static.put.io/images/putio-boncuk.png" width="72">
  </p>

  <h1>putio-swift</h1>

  <p>
    Swift library for <a href="https://api.put.io/v2/docs">put.io API v2</a>
  </p>

  <p>
    <img src="https://img.shields.io/cocoapods/v/PutioAPI" alt="Cocoapods">
    <img src="https://img.shields.io/github/license/putdotio/putio.swift" alt="GitHub">
  </p>
</div>

## Installation

`PutioAPI` is available through [CocoaPods](https://cocoapods.org/pods/PutioAPI). To install, simply add the following line to your Podfile:

```ruby
pod 'PutioAPI'
```

## Usage

See the [Example Project](./Example/PutioAPI/ViewController.swift) for a simple auth -> API call flow.

## Development

### Environment Setup

```bash
git clone git@github.com:putdotio/putio.swift.git

cd ./putio.swift

./scripts/setup.sh

open ./Example/PutioAPI.xcworkspace
```

### Bumping the Version

```bash
bundle exec pod-bump <patch|minor|major> --no-push
```
