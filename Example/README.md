# Example App

The example app is a lightweight smoke-test surface for the SDK's OAuth flow.

It integrates the local CocoaPods package as `PutioSDK`, while the in-code SDK type names remain `PutioAPI`.

## Setup

From the repository root:

```bash
make bootstrap
make example-install
open Example/PutioAPI.xcworkspace
```

## Usage

- run the `PutioAPI_Example` target
- enter your OAuth client ID
- complete the `ASWebAuthenticationSession` sign-in flow
- confirm the app can fetch account info after the callback

Do not commit personal tokens, client secrets, or test credentials from local smoke checks
