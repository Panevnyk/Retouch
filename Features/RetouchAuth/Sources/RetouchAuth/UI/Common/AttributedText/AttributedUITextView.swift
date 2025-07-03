import UIKit

public final class AttributedUITextView: UITextView, UITextViewDelegate {
    private let viewModel: AttributedTextViewModel
    private let isLightStyle: Bool
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        self.viewModel = AttributedTextViewModel(content: [])
        self.isLightStyle = false
        super.init(frame: frame, textContainer: textContainer)
        
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        self.viewModel = AttributedTextViewModel(content: [])
        self.isLightStyle = false
        super.init(coder: coder)
        
        initialize()
    }
    
    public init(
        viewModel: AttributedTextViewModel,
        isLightStyle: Bool
    ) {
        self.viewModel = viewModel
        self.isLightStyle = isLightStyle
        super.init(frame: .zero, textContainer: nil)
        
        initialize()
    }
    
    private func initialize() {
        isSelectable = true
        isEditable = false
        text = nil
        backgroundColor = .clear
        delegate = self
        tintColor = isLightStyle ? UIColor.white : UIColor.kPurple
        
        updateText()
    }
    
    private func updateText() {
        let attributedText = NSMutableAttributedString()
        
        for contentItem in viewModel.content {
            let attributedString = NSAttributedString(string: contentItem.text, attributes: contentItem.attributes)
            attributedText.append(attributedString)
        }
        
        self.attributedText = attributedText
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        viewModel.action?(URL)
        return false
    }
}
