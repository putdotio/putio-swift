.PHONY: bootstrap verify verify-spm example-install print-simulator-destination clean

bootstrap:
	bundle config set --local path vendor/bundle
	bundle install

verify:
	swift build
	bundle exec pod install --project-directory=Example
	@destination="$$(./scripts/xcode-iphone-simulator-destination.sh --workspace Example/PutioAPI.xcworkspace --scheme PutioSDK 2>/dev/null || true)"; \
	if [ -n "$$destination" ]; then \
		echo "Using Xcode iPhone simulator destination: $$destination"; \
		xcodebuild -workspace Example/PutioAPI.xcworkspace -scheme PutioSDK -configuration Debug -destination "$$destination" build CODE_SIGNING_ALLOWED=NO; \
	else \
		echo "No Xcode-advertised iPhone simulator destination on iOS 26.0 or newer. Falling back to the installed iphonesimulator SDK."; \
		xcodebuild -workspace Example/PutioAPI.xcworkspace -scheme PutioSDK -sdk iphonesimulator -configuration Debug build CODE_SIGNING_ALLOWED=NO; \
	fi

verify-spm:
	swift build

example-install:
	bundle exec pod install --project-directory=Example

print-simulator-destination:
	@./scripts/xcode-iphone-simulator-destination.sh --workspace Example/PutioAPI.xcworkspace --scheme PutioSDK

clean:
	rm -rf .build .bundle Package.resolved vendor/bundle Example/Pods
