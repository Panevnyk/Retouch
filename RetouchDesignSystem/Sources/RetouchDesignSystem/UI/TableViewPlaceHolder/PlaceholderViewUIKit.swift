//
//  TableViewPlaceholder.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 8/8/17.

import UIKit

@MainActor
public protocol PlaceholderViewDelegate: AnyObject {
    func didTapActionButton(from view: PlaceholderViewUIKit)
}

@objc(PlaceholderViewUIKit)
public final class PlaceholderViewUIKit: BaseCustomView {
    // MARK: - Propeties
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var textContentView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var actionButton: PurpleButton!

    // Delegate
    public weak var delegate: PlaceholderViewDelegate?

    // MARK: - initialize
    public override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .white
        titleLabel.font = .kBigTitleText
        titleLabel.textColor = UIColor.kTextDarkGray
        
        subtitleLabel.font = .kTitleBigText
        subtitleLabel.textColor = UIColor.kGrayText
    }
}

// MARK: - Public methods
extension PlaceholderViewUIKit {
    public func setTitle(_ text: String?) {
        titleLabel.text = text
    }
    
    public func setSubtitle(_ text: String?) {
        subtitleLabel.text = text
    }
    
    public func setImage(_ image: UIImage?) {
        imageView.image = image
    }

    public func setActionButtonTitle(_ text: String?) {
        actionButton.setTitle(text, for: .normal)
    }

    public func setActionButtonIsHidden(_ isHidden: Bool) {
        actionButton.isHidden = isHidden
    }
}

// MARK: - Actions
private extension PlaceholderViewUIKit {
    @IBAction func actionOfActionButton(_ sender: Any) {
        delegate?.didTapActionButton(from: self)
    }
}
