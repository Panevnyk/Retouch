//
//  RTAlertContentView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 07.04.2021.
//

import UIKit

@objc(RTAlertContentView)
public final class RTAlertContentView: UIView {
    // MARK: - Properties
    @IBOutlet private var xibView: UIView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var contentStackView: UIStackView!
    @IBOutlet private var actionsStackView: UIStackView!
    @IBOutlet private var bottomActionsStackView: UIStackView!
    @IBOutlet private var closeButton: UIButton!

    /// Position of buttons with actions
    public var actionPositionStyle: NSLayoutConstraint.Axis?

    // MARK: - Inits
    public convenience init(title: String?, message: String?, image: UIImage?) {
        self.init()

        addSelfNibUsingConstraints(bundle: Bundle.module)

        translatesAutoresizingMaskIntoConstraints = false

        layer.masksToBounds = true
        layer.cornerRadius = 6

        if title?.isEmpty ?? true {
            titleLabel.isHidden = true
        }

        if image == nil {
            imageView.isHidden = true
        }

        titleLabel.font = .kBigTitleText
        titleLabel.textColor = .black

        messageLabel.font = .kPlainBigText
        messageLabel.textColor = .kGrayText

        titleLabel.text = title
        messageLabel.text = message
        imageView.image = image
    }

    // MARK: - Public methods
    public func enableCloseButton(with target: Any?, action: Selector) {
        closeButton.isEnabled = true
        closeButton.isHidden = false
        closeButton.addTarget(target, action: action, for: .touchUpInside)
    }

    // MARK: - Internal methods
    /// Adds Content to inner StackView
    ///
    /// - Parameter content: Any UIView subclass
    func add(content: UIView) {
        contentStackView.addArrangedSubview(content)
    }

    /// Adds Content to inner StackView
    ///
    /// - Parameters:
    ///   - content: Any UIView subclass
    ///   - size: Size of content. It'll add constraints to this view automatically.
    func add(content: UIView, size: CGSize) {
        add(content: content)

        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        content.widthAnchor.constraint(equalToConstant: size.width),
                                        content.heightAnchor.constraint(equalToConstant: size.height)])
    }

    /// Adds Action to the inner StackView
    ///
    /// - Parameter action: An RTAlertAction subclass object, which wraps action and appearance
    func add(action: RTAlertAction) {
        self.actionsStackView.addArrangedSubview(action)

        let numberOfItems = self.actionsStackView.arrangedSubviews.count
        if let axis = actionPositionStyle {
            self.actionsStackView.axis = axis
        } else {
            self.actionsStackView.axis = numberOfItems > 2 ? .vertical : .horizontal
        }
    }

    /// Adds Action to the inner bottom StackView (specific case)
    ///
    /// - Parameter action: An RTAlertAction subclass object, which wraps action and appearance
    func addToBottom(action: RTAlertAction) {
        self.bottomActionsStackView.addArrangedSubview(action)
    }
}

