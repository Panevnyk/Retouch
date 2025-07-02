//
//  CanceledPhotoViewController.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 11.03.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem

@objc(MessageViewController)
public final class MessageViewController: UIViewController {
    // MARK: - Properties
    // UI
    @IBOutlet private var closeButton: CloseButton!
    @IBOutlet private var designerImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!

    // Data
    public var imageString = ""
    public var screenTitle = ""
    public var message = ""

    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - SetupUI
private extension MessageViewController {
    func setupUI() {
        view.backgroundColor = .white

        designerImage.image =
            UIImage(named: imageString, in: Bundle.designSystem, compatibleWith: nil)
        designerImage.contentMode = .scaleAspectFill

        titleLabel.font = .kBigTitleText
        titleLabel.textColor = .black
        titleLabel.text = screenTitle

        messageLabel.font = .kSectionHeaderText
        messageLabel.textColor = .kGrayText
        messageLabel.text = message
    }
}

// MARK: - Actions
private extension MessageViewController {
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
