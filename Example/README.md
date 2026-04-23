# Example App

The example app is a lightweight smoke-test surface for the SDK's OAuth flow.

It integrates the local CocoaPods package as `PutioSDK`, and the in-code SDK surface also uses `PutioSDK`.
The example app uses the async `PutioSDK` APIs directly so it stays aligned with the recommended public surface.

## Setup

From the repository root:

```bash
make bootstrap
make example-install
open Example/PutioSDK.xcworkspace
```

## Usage

- run the `PutioSDK_Example` target
- enter your OAuth client ID
- complete the `ASWebAuthenticationSession` sign-in flow
- confirm the app can fetch account info and list files after the callback

Do not commit personal tokens, client secrets, or test credentials from local smoke checks
