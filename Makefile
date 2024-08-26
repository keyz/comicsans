.PHONY: build
build:
	swift build -c release --disable-sandbox

.PHONY: build/universal
build/universal:
	swift build -c release --disable-sandbox --arch arm64 --arch x86_64

.PHONY: clean
clean:
	swift package clean

.PHONY: format
format:
	swiftformat .

.PHONY: reopen
reopen:
	osascript -e 'tell app "Xcode" to quit' && open Package.swift

.PHONY: test
test:
	swift test
