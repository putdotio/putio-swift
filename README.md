# PutioAPI

[![Build Status](https://travis-ci.org/putdotio/putio.swift.svg?branch=master)](https://travis-ci.org/putdotio/putio.swift)
![Cocoapods](https://img.shields.io/cocoapods/v/PutioAPI)
![GitHub](https://img.shields.io/github/license/putdotio/putio.swift)

Swift wrapper for [Put.io API v2](https://api.put.io). Used in [official Put.io iOS](https://itunes.apple.com/us/app/put-io/id1260479699?mt=8) app.

## Installation

`PutioAPI` is available through [CocoaPods](https://cocoapods.org/pods/PutioAPI. To install, simply add the following line to your Podfile:

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
