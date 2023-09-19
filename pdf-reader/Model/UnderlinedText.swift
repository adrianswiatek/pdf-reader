struct UnderlinedText {
    let preunderlined: String
    let underlined: String
    let postunderlined: String

    private init(
        _ preunderlined: String,
        _ underlined: String,
        _ postunderlined: String
    ) {
        self.preunderlined = preunderlined
        self.underlined = underlined
        self.postunderlined = postunderlined
    }

    static func just(_ text: String) -> UnderlinedText {
        UnderlinedText(text, "", "")
    }

    static func fromText(_ text: String, andRange range: Range<String.Index>) -> UnderlinedText {
        UnderlinedText(
            String(text[..<range.lowerBound]),
            String(text[range.lowerBound..<range.upperBound]),
            String(text[range.upperBound...])
        )
    }

    static func fromText(_ text: String) -> (Range<String.Index>) -> UnderlinedText {
        { range in fromText(text, andRange: range) }
    }
}
