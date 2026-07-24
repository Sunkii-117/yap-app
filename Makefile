SCHEME=Yap
DEST=platform=iOS Simulator,name=iPhone 17

generate:
	xcodegen generate

build: generate
	xcodebuild build -scheme $(SCHEME) -destination '$(DEST)'

test: generate
	xcodebuild test -scheme $(SCHEME) -destination '$(DEST)'
