.PHONY: bootstrap verify example-install print-simulator-destination clean

bootstrap:
	bundle config set --local path vendor/bundle
	bundle install

verify:
	bundle exec pod install --project-directory=Example
	@destination="$$(./scripts/xcode-iphone-simulator-destination.sh --workspace Example/PutioAPI.xcworkspace --scheme PutioAPI 2>/dev/null || true)"; \
	if [ -n "$$destination" ]; then \
		echo "Using Xcode iPhone simulator destination: $$destination"; \
		xcodebuild -workspace Example/PutioAPI.xcworkspace -scheme PutioAPI -configuration Debug -destination "$$destination" build CODE_SIGNING_ALLOWED=NO; \
	else \
		echo "No Xcode-advertised iPhone simulator destination on iOS 26.0 or newer. Falling back to the installed iphonesimulator SDK."; \
		xcodebuild -workspace Example/PutioAPI.xcworkspace -scheme PutioAPI -sdk iphonesimulator -configuration Debug build CODE_SIGNING_ALLOWED=NO; \
	fi

example-install:
	bundle exec pod install --project-directory=Example

print-simulator-destination:
	@./scripts/xcode-iphone-simulator-destination.sh --workspace Example/PutioAPI.xcworkspace --scheme PutioAPI

clean:
	rm -rf .bundle vendor/bundle Example/Pods
