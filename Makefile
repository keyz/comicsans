.PHONY: build
build:
	swift build -c release --disable-sandbox

.PHONY: build/universal
build/universal:
	swift build -c release --disable-sandbox --arch arm64 --arch x86_64

.PHONY: clean
clean:
	swift package clean
	rm -rf ./.release/

.PHONY: format
format:
	swiftformat .

.PHONY: reopen
reopen:
	osascript -e 'tell app "Xcode" to quit' && open ./Package.swift

.PHONY: tarball
tarball: build/universal
	mkdir -p ./.release/
	tar -cvzf ./.release/macOS-universal.tar.gz -C ./.build/apple/Products/Release cs
	cd ./.release/ && shasum -a 256 macOS-universal.tar.gz > checksums.txt
	cd ./.release/ && shasum -a 256 -c checksums.txt

.PHONY: test
test:
	swift test
