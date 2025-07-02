//
//  RetouchingPhotoViewController.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 14.02.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

@objc(RetouchingPhotoViewController)
public final class RetouchingPhotoViewController: UIViewController {
    // MARK: - Properties
    @Injected(\.analytics) private var analytics
    
    // UI
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var closeButton: CloseButton!
    @IBOutlet private var designerImage: UIImageView!
    @IBOutlet private var retouchingProgressView: RetouchingProgressView!
    @IBOutlet private var backToAppTitleLabel: UILabel!
    @IBOutlet private var backToAppButton: PurpleButton!
    @IBOutlet private var timeCounterLabel: UILabel!

    // ViewModel
    public var viewModel: RetouchingPhotoViewModelProtocol!

    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        analytics.logScreen(.retouchingPhoto)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startTimer()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.invalidateTimer()
    }
}

// MARK: - SetupUI
private extension RetouchingPhotoViewController {
    func setupUI() {
        view.backgroundColor = .white

        titleLabel.font = .kBigTitleText
        titleLabel.textColor = .black
        titleLabel.text = "Photo is retouching"

        designerImage.image =
            UIImage(named: "icPhotoRetouchingWaiting", in: Bundle.designSystem, compatibleWith: nil)
        designerImage.contentMode = .scaleAspectFill

        retouchingProgressView.fill(
            states: ["In queue", "Retouching", "Ready!"],
            activeIndex: 1)

        timeCounterLabel.numberOfLines = 0
        timeCounterLabel.textAlignment = .center
        timeCounterLabel.font = .kTitleBigText
        timeCounterLabel.textColor = .kGrayText
        timeCounterLabel.text = "Waiting..."

        backToAppTitleLabel.font = .kDescriptionText
        backToAppTitleLabel.textColor = .kGrayText
        backToAppTitleLabel.text = "You can open this page from home screen*"

        backToAppButton.setTitle("Back to home screen", for: .normal)
    }
}

// MARK: - RetouchingPhotoViewModelDelegate
extension RetouchingPhotoViewController: RetouchingPhotoViewModelDelegate {
    public func didChangeToIndex(_ index: Int, animated: Bool) {
        retouchingProgressView.setActiveIndex(activeIndex: index + 1, animated: animated)
    }

    public func didChangeTimer(_ leftTime: String) {
        timeCounterLabel.text = leftTime
    }
}

// MARK: - Actions
private extension RetouchingPhotoViewController {
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func backToAppAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
