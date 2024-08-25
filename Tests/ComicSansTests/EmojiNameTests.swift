import ComicSans
import XCTest

class EmojiNameTests: XCTestCase {
    func testBasicPunctuationReplacement() {
        let input = "Hello... @world!"
        let expected = "hello-ellipsis-at-world-exclamation-mark"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testQuotesReplacement() {
        let input = "She said, \"Hello\"."
        let expected = "she-said-comma-quote-hello-unquote-full-stop"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testMultipleQuotesReplacement() {
        let input = "\"Hello,\" she said. \"How are you?\""
        let expected = "quote-hello-comma-unquote-she-said-full-stop-quote-how-are-you-question-mark-unquote"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testUnknownCharacterHandling() {
        let input = "🙂"
        let expected = "unknown"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testEmptyString() {
        let input = ""
        let expected = "unknown"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testWhitespaceOnlyString() {
        let input = "   \n  "
        let expected = "unknown"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testComplexString() {
        let input = "Hello, world! -- It's a test…"
        let expected = "hello-comma-world-exclamation-mark-dash-dash-its-a-test-ellipsis"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testStringWithNoSpecialCharacters() {
        let input = "Hello world"
        let expected = "hello-world"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testStringWithNumbers() {
        let input = "The price is $100.00!"
        let expected = "the-price-is-dollar-sign-100-full-stop-00-exclamation-mark"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testStringWithMultipleDashes() {
        let input = "Dash - and en dash – and em dash —."
        let expected = "dash-dash-and-en-dash-en-dash-and-em-dash-em-dash-full-stop"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testStringWithSlashes() {
        let input = "Slash / and backslash \\ are different."
        let expected = "slash-slash-and-backslash-backslash-are-different-full-stop"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testSpecialCharactersOnly() {
        let input = "%^*()"
        let expected = "unknown"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testStringWithMixedQuotesAndSymbols() {
        let input = "\"Let's try this!\", she said. \"It's crazy…\""
        let expected = "quote-lets-try-this-exclamation-mark-unquote-comma-she-said-full-stop-quote-its-crazy-ellipsis-unquote"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testTrimmedInputString() {
        let input = "   Trimmed   "
        let expected = "trimmed"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testComplexUnicodeCharacters() {
        let input = "Emoji test: 😀 😁 😂 🤣"
        let expected = "emoji-test-colon"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testApostropheHandling() {
        let input = "It's a beautiful day"
        let expected = "its-a-beautiful-day"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testParenthesesHandling() {
        let input = "Hello (world)"
        let expected = "hello-world"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testAdditionalSymbols() {
        let input = "Test %*+=<>[]{}|^~"
        let expected = "test"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testLeadingTrailingWhitespace() {
        let input = "  Hello, World!  "
        let expected = "hello-comma-world-exclamation-mark"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testConsecutivePunctuation() {
        let input = "Hello!? What's going on..."
        let expected = "hello-exclamation-mark-question-mark-whats-going-on-ellipsis"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testMixedCaseHandling() {
        let input = "HeLLo WoRLd"
        let expected = "hello-world"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testNonBreakingSpace() {
        let input = "Hello\u{00A0}\n\nWorld"
        let expected = "hello-world"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testTabCharacter() {
        let input = "Hello\tWorld"
        let expected = "hello-world"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }

    func testAllReplacementCharacters() {
        let input = "...\u{2026}.,?:!;-–—/\\$\""
        let expected = "ellipsis-ellipsis-full-stop-comma-question-mark-colon-exclamation-mark-semicolon-dash-en-dash-em-dash-slash-backslash-dollar-sign-quote"
        XCTAssertEqual(ComicSans(input).emojiName(), expected)
    }
}
