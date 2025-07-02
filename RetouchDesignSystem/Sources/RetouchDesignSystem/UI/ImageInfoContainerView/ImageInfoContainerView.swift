//
//  ImageInfoContainerView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit

@MainActor
public protocol ImageInfoContainerViewDelegate: AnyObject {
    func didTapRemoveOrder(from view: ImageInfoContainerView)
    func didTapRatingOrder(from view: ImageInfoContainerView)
    func didTapDownload(from view: ImageInfoContainerView)
    func didTapShare(from view: ImageInfoContainerView)
    func didTapRedo(from view: ImageInfoContainerView)
    
//    func didTapRating(from view: ImageInfoContainerView)
}

@objc(ImageInfoContainerView)
public final class ImageInfoContainerView: BaseCustomView {
    // MARK: - Properties
    // UI
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var longTapInfoLabel: UILabel!
    @IBOutlet private var moreButton: UIButton!
    @IBOutlet private var actionsStackView: UIStackView!

    @IBOutlet private var cnstrBottomSpaceStackView: NSLayoutConstraint!

    // Delegate
    public weak var delegate: ImageInfoContainerViewDelegate?

    // MARK: - initialize
    public override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)
        setupUI()
    }

    // MARK: - Public methods
    public func fill(viewModel: ImageInfoContainerViewModelProtocol) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description

        moreButton.isHidden = !viewModel.isActionAvailable
        cnstrBottomSpaceStackView.constant = viewModel.isActionAvailable ? 13 : 0
        actionsStackView.removeAllArrangeSubviews()

        if viewModel.isActionAvailable {
            if viewModel.isDownloadAndShareAvailable {
                addDownloadAndShareButtons()
            }

            actionsStackView.addArrangedSubview(UIView())
            
            if viewModel.idRedoAvailable {
                addRedoButton()
            }
        }
    }
}

// MARK: - SetupUI
private extension ImageInfoContainerView {
    func setupUI() {
        backgroundColor = .kBackground
        layer.cornerRadius = 16
        layer.masksToBounds = true
        layer.borderColor = UIColor.kSeparatorGray.cgColor
        layer.borderWidth = 1

        titleLabel.font = .kTitleBigText
        titleLabel.textColor = .black

        descriptionLabel.font = .kPlainText
        descriptionLabel.textColor = .black
        
        let moreImg = UIImage(named: "icMoreBlack", in: Bundle.module, compatibleWith: nil)?
            .withRenderingMode(.alwaysOriginal)
        moreButton.setImage(moreImg, for: .normal)

        longTapInfoLabel.font = .kDescriptionText
        longTapInfoLabel.textColor = .kGrayText
        longTapInfoLabel.text = "Longtap for see original photo*"
    }

    func addDownloadAndShareButtons() {
        let download = UIButton(type: .system)
        download.setImage(
            UIImage(named: "icDownload", in: Bundle.module, compatibleWith: nil)?
                .withRenderingMode(.alwaysOriginal),
            for: .normal)
        download.addTarget(self, action: #selector(didTapDownload), for: .touchUpInside)
        download.translatesAutoresizingMaskIntoConstraints = false
        download.heightAnchor.constraint(equalToConstant: 32).isActive = true
        download.widthAnchor.constraint(equalToConstant: 24).isActive = true

        let share = UIButton(type: .system)
        share.setImage(
            UIImage(named: "icShare", in: Bundle.module, compatibleWith: nil)?
                .withRenderingMode(.alwaysOriginal),
            for: .normal)
        share.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        share.translatesAutoresizingMaskIntoConstraints = false
        share.heightAnchor.constraint(equalToConstant: 32).isActive = true
        share.widthAnchor.constraint(equalToConstant: 24).isActive = true

        actionsStackView.addArrangedSubview(download)
        actionsStackView.addArrangedSubview(share)
    }

    
    func addRedoButton() {
        let redoButton = RedoButton(type: .system)
        redoButton.translatesAutoresizingMaskIntoConstraints = false
        redoButton.addTarget(self, action: #selector(didTapRedo), for: .touchUpInside)
        redoButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        actionsStackView.addArrangedSubview(redoButton)
    }
}

// MARK: - Actions
private extension ImageInfoContainerView {
    @IBAction func didTapMore(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

//        let removeAction = UIAlertAction(title: "Remove Order", style: .default) { [weak self] _ in
//            guard let self = self else { return }
//            self.delegate?.didTapRemoveOrder(from: self)
//        }
        let ratingAction = UIAlertAction(title: "Add current retouching rating", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didTapRatingOrder(from: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        alert.addAction(removeAction)
        alert.addAction(ratingAction)
        alert.addAction(cancelAction)
        
        UIApplication.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func didTapDownload(_ sender: UIButton) {
        delegate?.didTapDownload(from: self)
    }

    @objc func didTapShare(_ sender: UIButton) {
        delegate?.didTapShare(from: self)
    }

    @objc func didTapRedo(_ sender: UIButton) {
        delegate?.didTapRedo(from: self)
    }
}
