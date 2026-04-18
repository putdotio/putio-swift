.PHONY: bootstrap verify example-install clean

bootstrap:
	bundle config set --local path vendor/bundle
	bundle install

verify:
	bundle exec pod install --project-directory=Example
	xcodebuild -workspace Example/PutioAPI.xcworkspace -scheme PutioAPI -sdk iphonesimulator -configuration Debug build CODE_SIGNING_ALLOWED=NO

example-install:
	bundle exec pod install --project-directory=Example

clean:
	rm -rf .bundle vendor/bundle Example/Pods
