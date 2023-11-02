<div align="center">
  <p>
    <img src="https://static.put.io/images/putio-boncuk.png" width="72">
  </p>

  <h1>putio-swift</h1>

  <p>
    Swift SDK for interacting with the <a href="https://api.put.io/v2/docs">put.io API.</a>
  </p>

  <p>
    <img src="https://img.shields.io/cocoapods/v/PutioAPI" alt="Cocoapods">
    <img src="https://img.shields.io/github/license/putdotio/putio-swift" alt="GitHub">
  </p>
</div>

## Installation

`PutioAPI` is available through [CocoaPods](https://cocoapods.org/pods/PutioAPI). To install, simply add the following line to your Podfile:

```ruby
pod 'PutioAPI'
```

## Usage

See the [Example Project](./Example/PutioAPI/ViewController.swift) for a simple auth -> API call flow.

### Development

Clone the repo.

```bash
git clone git@github.com:putdotio/putio-swift.git
cd ./putio-swift
```

Install the package managers, it's suggested to use `rbenv` and `bundler` for convenience.

```bash
gem install bundler # if you don't have bundler
bundle install
```

Install the dependencies then open the workspace.

```bash
./scripts/setup.sh
open ./Example/PutioAPI.xcworkspace
```
