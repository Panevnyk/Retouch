//
//  DescriptionView.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 03.06.2021.
//

import UIKit

@objc(DescriptionView)
public final class DescriptionView: BaseTapableView {
    // MARK: - Properties
    @IBOutlet private var xibView: UIView!
    @IBOutlet private var pencilImageView: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!
    
    private var isActive = false
    private var text: String?
    private var placeholderText: String?
    
    // MARK: - initialize
    public override func initialize() {
        super.initialize()
        addSelfNibUsingConstraints(bundle: Bundle.module)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .kInputBackgroundGrey
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
        pencilImageView.image = UIImage(named: "icPencil", in: Bundle.module, compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        
        descriptionLabel.font = .kPlainText
        
        setIsActive(true)
    }
    
    // MARK: - Public methods
    public func setPlaceholderText(_ text: String) {
        self.placeholderText = text
        setIsActive(isActive)
    }
    
    public func setText(_ text: String) {
        self.text = text
        setIsActive(isActive)
    }
    
    public func setIsActive(_ isActive: Bool) {
        self.isActive = isActive
        
        isUserInteractionEnabled = isActive
        pencilImageView.tintColor = isActive ? .kGrayText : .kGrayText.withAlphaComponent(0.3)
        descriptionLabel.textColor = isActive ? .kGrayText : .kGrayText.withAlphaComponent(0.3)
        descriptionLabel.text = isActive ? getActiveText() : placeholderText
    }
    
    private func getActiveText() -> String? {
        if let text = text, !text.isEmpty {
            return text
        }
        return placeholderText
    }
}
