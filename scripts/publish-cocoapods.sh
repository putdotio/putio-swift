#!/bin/sh

set -eu

version="${1:-}"

if [ -z "$version" ]; then
  echo "usage: $0 <version>" >&2
  exit 1
fi

if [ -z "${COCOAPODS_TRUNK_TOKEN:-}" ]; then
  echo "COCOAPODS_TRUNK_TOKEN is not set; skipping CocoaPods publish for $version"
  exit 0
fi

bundle exec pod trunk push PutioSDK.podspec --allow-warnings
bundle exec pod trunk push PutioAPI.podspec --allow-warnings
