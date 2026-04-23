# SDK Readiness

This document tracks how ready `putio-sdk-swift` is for autonomous agent work and public package maintenance.

## Overall Status

- deterministic package-level unit tests now exist under `Tests/PutioSDKTests`
- an opt-in live verification layer exists under `Tests/PutioSDKLiveTests`
- the shared transport now has a native async `URLSession` path with `Decodable` boundary parsing for the modernized domains
- typed failures now conform to `LocalizedError` and carry recovery guidance
- `make verify` is the canonical deterministic guardrail
- `make live-test` is the opt-in real API verification lane

## Current Confidence

| Area | Status | Notes |
| --- | --- | --- |
| Package boot | `good` | `make bootstrap` and `make verify` are documented and exercised in CI |
| Unit verification | `medium` | request config, async transport, localized errors, and the modernized account/auth/history/files search-playback/grants/routes/subtitles/trash domains now have package-level coverage, but the API surface still needs broader domain-by-domain tests |
| Live verification | `medium` | account and disposable file/trash flows are live-covered; more namespaces still need safe real-API targets |
| Release readiness | `good` | `main` stays verify-first, with semantic-release and optional CocoaPods publishing |

## Highest-Value Next Gaps

1. extend deterministic tests deeper across account, auth, files, history, and trash namespaces
2. add more live coverage for safe read and reversible mutation flows
3. finish migrating the remaining JSON-heavy completion payloads onto the async decoded surface
