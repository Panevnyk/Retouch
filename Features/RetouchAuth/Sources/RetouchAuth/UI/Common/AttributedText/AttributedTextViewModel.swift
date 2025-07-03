import Foundation

public struct AttributedText {
    public var text: String
    public var attributes: [NSAttributedString.Key: Any]
    
    public init(text: String, attributes: [NSAttributedString.Key : Any]) {
        self.text = text
        self.attributes = attributes
    }
}

public class AttributedTextViewModel {
    public let content: [AttributedText]
    public var action: ((_ url: URL) -> Void)?
    
    public init(content: [AttributedText]) {
        self.content = content
    }
}
