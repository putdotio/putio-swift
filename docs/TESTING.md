# Testing

## Commands

```bash
make verify
make live-test
```

`make verify` is the deterministic repo gate. It runs the Swift package tests, then builds the package and the example-backed CocoaPods workspace.

`make live-test` is opt-in. It runs real API checks against a configured put.io test account and stays separate from the default verify path.

## Verification Shape

- `make verify` runs package-level SwiftPM tests
- `make verify` exercises the async `URLSession` transport and decoded model slice through `PutioSDKTests`
- `make verify` then builds the Swift package and the example-backed `PutioSDK` CocoaPods scheme
- `make live-test` runs live SwiftPM tests filtered to `PutioSDKLiveTests`
- GitHub Actions currently runs only `make verify`

## Live Environment

Default example env file:

- `.env.example`

Supported direct runtime variables:

- `PUTIO_TOKEN_FIRST_PARTY`
- `PUTIO_ACCESS_TOKEN`
- `PUTIO_TOKEN`
- `PUTIO_CLIENT_ID`
- `PUTIO_BASE_URL`

Optional 1Password-backed runtime variables:

- `OP_SERVICE_ACCOUNT_TOKEN`
- `PUTIO_1PASSWORD_RUNTIME_ITEM_ID`
- `PUTIO_1PASSWORD_RUNTIME_VAULT`

The live harness prefers direct runtime variables first. If they are missing, it can hydrate the shared runtime token and client id from a 1Password item when all three optional 1Password variables are set.

## Live Scope

Current live targets cover:

- account info against the real API
- disposable folder create, delete, trash restore, and cleanup flows

## Safety Rules

Allowed in `make live-test`:

- read-only account probes
- disposable file and trash flows with cleanup

Excluded from `make live-test`:

- destructive account mutations
- trash emptying
- any mutation without cleanup
