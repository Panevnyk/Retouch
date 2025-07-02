//
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 09.02.2021.
//

import UIKit

public protocol MessageTextInputViewDelegate: AnyObject {
    func textDidChangeManually(_ text: String)
}

@objc(MessageTextInputView)
public final class MessageTextInputView: BaseCustomView {
    // MARK: - Properties
    // UI
    @IBOutlet public var textViewContainer: UIView!
    @IBOutlet public var messageTextView: UITextView!

    private let placeholderLabel = UILabel()
    
    // Delegate
    public weak var delegate: MessageTextInputViewDelegate?

    // MARK: - initialize
    public override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)
        setupUI()
    }
}

// MARK: - Public methods
public extension MessageTextInputView {
    func showKeyboard() {
        messageTextView.becomeFirstResponder()
    }
    
    func dismissKeyboard() {
        messageTextView.resignFirstResponder()
    }
    
    func clear() {
        messageTextView.text = nil
        textViewDidChange(messageTextView)
    }

    func setPlaceholder(_ text: String) {
        placeholderLabel.text = text
    }

    func setText(_ text: String) {
        messageTextView.text = text
        textViewDidChangeManually(messageTextView)
    }
}

// MARK: - UI
private extension MessageTextInputView {
    func setupUI() {
        backgroundColor = .clear

        textViewContainer.layer.cornerRadius = 6
        textViewContainer.layer.masksToBounds = true
        textViewContainer.backgroundColor = UIColor.kInputBackgroundGrey

        messageTextView.delegate = self
        messageTextView.backgroundColor = UIColor.kInputBackgroundGrey
        messageTextView.text = ""
        messageTextView.textColor = UIColor.kTextDarkGray
        messageTextView.returnKeyType = .done

        addPlaceholder("Placeholder",
                       placeholderColor: UIColor.kGrayText,
                       placeholderFont: UIFont.kPlainText)
    }
}

/// Adds a placeholder UILabel to this UITextView
private extension MessageTextInputView {
    func addPlaceholder(_ placeholderText: String,
                        placeholderColor: UIColor? = nil,
                        placeholderFont: UIFont? = nil) {
        placeholderLabel.text = placeholderText
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderLabel.font = placeholderFont != nil ? placeholderFont : messageTextView.font
        placeholderLabel.textColor = placeholderColor != nil ? placeholderColor : UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = messageTextView.text.count > 0
        
        messageTextView.addSubview(placeholderLabel)

        NSLayoutConstraint.activate([placeholderLabel.topAnchor.constraint(equalTo: messageTextView.topAnchor, constant: 8),
                                     placeholderLabel.leftAnchor.constraint(equalTo: messageTextView.leftAnchor, constant: 4),
                                     messageTextView.bottomAnchor.constraint(equalTo: placeholderLabel.bottomAnchor),
                                     messageTextView.rightAnchor.constraint(equalTo: placeholderLabel.rightAnchor)])
    }
}

// MARK: UITextViewDelegate
extension MessageTextInputView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        textViewDidChangeManually(textView)
        delegate?.textDidChangeManually(textView.text)
    }

    private func textViewDidChangeManually(_ textView: UITextView) {
        if let placeholderLabel = viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = messageTextView.text.count > 0
        }

        adjustTextViewSize(textView)
    }
    
    private func adjustTextViewSize(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height
                && constraint.constant != estimatedSize.height {
                constraint.constant = estimatedSize.height > 200 ? 200 : estimatedSize.height
                textView.scrollToBottom(isAnimated: false)
            }
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        return true
    }
}
