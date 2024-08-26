.PHONY: build
build:
	swift build -c release --disable-sandbox

.PHONY: clean
clean:
	swift package clean

.PHONY: test
test:
	swift test
