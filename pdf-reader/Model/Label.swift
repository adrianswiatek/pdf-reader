import Foundation
import PDFKit

struct Label: Equatable, Hashable {
    let text: String
    let textToBeUnderlined: String

    private init(text: String, textToBeUnderlinded: String) {
        self.text = text
        self.textToBeUnderlined = textToBeUnderlinded
    }

    static func fromString(_ string: String) -> Label {
        Label(text: string, textToBeUnderlinded: "")
    }

    func withUnderlined(_ textToBeUnderlined: String) -> Label {
        Label(text: text, textToBeUnderlinded: textToBeUnderlined)
    }

    func underlinedText() -> UnderlinedText {
        let underlinedText = text
            .range(of: textToBeUnderlined, options: .caseInsensitive)
            .map(UnderlinedText.fromText(text))
        return underlinedText ?? .just(text)
    }

    func contains(_ textToBeChecked: String) -> Bool {
        text.range(of: textToBeChecked, options: .caseInsensitive) != nil
    }
}
