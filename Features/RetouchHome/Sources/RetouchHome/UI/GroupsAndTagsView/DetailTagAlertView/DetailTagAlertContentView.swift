//
//  DetailTagAlertContentView.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 03.06.2021.
//

import UIKit
import RetouchDesignSystem

@MainActor
public protocol DetailTagAlertContentViewDelegate: AnyObject {
    func didSelectCancel(from view: DetailTagAlertContentView)
    func didSelectAdd(value: String?, from view: DetailTagAlertContentView)
}

@objc(DetailTagAlertContentView)
public final class DetailTagAlertContentView: UIView {
    // MARK: - Properties
    @IBOutlet private var xibView: UIView!
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private var groupContentView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var groupTitleLabel: UILabel!
    
    @IBOutlet private var tagContentView: UIView!
    @IBOutlet private var tagTitleLabel: UILabel!
    @IBOutlet private var checkerImageView: UIImageView!
    @IBOutlet private var tagTriangleView: TriangleView!
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    
    @IBOutlet private var messageTextInputView: MessageTextInputView!
    
    @IBOutlet private var cancelButton: ReversePurpleButton!
    @IBOutlet private var addButton: PurpleButton!
    
    public weak var delegate: DetailTagAlertContentViewDelegate?
    
    /// Position of buttons with actions
    public var actionPositionStyle: NSLayoutConstraint.Axis?

    // MARK: - Inits
    public convenience init(presentableRetouchData: PresentableRetouchData) {
        self.init()

        addSelfNibUsingConstraints(bundle: Bundle.module)

        translatesAutoresizingMaskIntoConstraints = false

        layer.masksToBounds = true
        layer.cornerRadius = 6
        
        groupContentView.backgroundColor = .white
        groupContentView.layer.masksToBounds = true
        groupContentView.layer.cornerRadius = 6
        groupContentView.layer.borderWidth = 1
        groupContentView.layer.borderColor = UIColor.kPurple.cgColor
        
        groupTitleLabel.font = .kDescriptionText
        groupTitleLabel.textColor = .kPurple
        groupTitleLabel.text = presentableRetouchData.retouchGroup.title
        
        imageView.image =
            UIImage(named: presentableRetouchData.retouchGroup.image, in: Bundle.designSystem, compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .kPurple
        
        titleLabel.font = .kTitleBigText
        titleLabel.textColor = .black
        titleLabel.text = "Please, tell us what you want to change"

        messageLabel.font = .kDescriptionText
        messageLabel.textColor = .kGrayText
        messageLabel.text = "Should changes be really visible?\n\nOr retouching should make photo just a bit smoother?\n\nGive us any details “What”, “Where”, “How much”\nand we’ll do everything for amaizing result."
        
        tagContentView.backgroundColor = .kPurpleAlpha10
        tagContentView.layer.cornerRadius = 6
        tagContentView.layer.masksToBounds = true
        
        tagTitleLabel.font = .kDescriptionText
        tagTitleLabel.textColor = .kPurple
        tagTitleLabel.text = presentableRetouchData.tag.title
        
        checkerImageView.image =
            UIImage(named: "icCheckerPurple", in: Bundle.designSystem, compatibleWith: nil)
        
        messageTextInputView.setPlaceholder("Give our designers more details")
        if let tagDescription = presentableRetouchData.tag.tagDescription {
            messageTextInputView.setText(tagDescription)
        }
        
        cancelButton.setTitle("Cancel", for: .normal)
        addButton.setTitle("Add", for: .normal)
    }
    
    func showKeyboard() {
        messageTextInputView.showKeyboard()
    }
}

// MARK: - Actions
private extension DetailTagAlertContentView {
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.didSelectCancel(from: self)
    }
    
    @IBAction func addAction(_ sender: Any) {
        delegate?.didSelectAdd(value: messageTextInputView.messageTextView.text, from: self)
    }
}

