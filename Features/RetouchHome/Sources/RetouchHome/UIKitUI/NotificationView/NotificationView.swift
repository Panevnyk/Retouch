//
//  NotificationView.swift
//  RetouchHome
//
//  Created by Panevnyk Vlad on 27.01.2022.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem

@objc(NotificationView)
final class NotificationView: BaseCustomView {
    // MARK: - Properties
    @IBOutlet private var xibView: UIView!
    @IBOutlet private var indicatorImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var closeButton: UIButton!
    
    private var closeCallback: (() -> Void)?
    
    // MARK: - Initialize
    override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)
        setupUI()
    }
    
    // MARK: - UI
    private func setupUI() {
        layer.cornerRadius = 4
        addBottomContainerShadow()
        
        xibView.layer.cornerRadius = 4
        xibView.layer.masksToBounds = true
        titleLabel.font = UIFont.kTitleBigBoldText
        descriptionLabel.font = UIFont.kPlainText
        let image = UIImage(named: "icCloseGray", in: Bundle.designSystem, compatibleWith: nil)
        closeButton.setImage(image, for: .normal)
    }
    
    // MARK: - Setup
    func setup(viewModel: NotificationBannerViewModel) {
        titleLabel.text = viewModel.notificationTitle
        if let attributedNotificationDescription = viewModel.attributedNotificationDescription {
            descriptionLabel.attributedText = attributedNotificationDescription
        } else if let notificationDescription = viewModel.notificationDescription {
            descriptionLabel.text = notificationDescription
        }
        indicatorImageView.image = viewModel.indicatorImage
        closeCallback = viewModel.closeAction
    }
}

// MARK: - Actions
private extension NotificationView {
    @IBAction func closeAction(_ sender: Any) {
        closeCallback?()
    }
}
