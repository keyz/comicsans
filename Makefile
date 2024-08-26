.PHONY: build
build:
	swift build -c release --disable-sandbox

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
