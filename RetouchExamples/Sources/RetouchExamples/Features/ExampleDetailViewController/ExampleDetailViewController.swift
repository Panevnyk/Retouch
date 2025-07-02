//
//  ExampleDetailViewController.swift
//  RetouchExamples
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

@objc(ExampleDetailViewController)
public final class ExampleDetailViewController: UIViewController {
    // MARK: - Properties
    @Injected(\.analytics) private var analytics
    
    // UI
    @IBOutlet private var beforeAfterImagePresentableView: BeforeAfterImagePresentableView!
    @IBOutlet private var bottomContainerView: ImageInfoContainerView!
    @IBOutlet private var backButton: BackButton1!
    @IBOutlet private var eyeButton: EyeButton!
    @IBOutlet private var longTapTutorialView: LongTapTutorialView!
    @IBOutlet private var waterSignImageView: UIImageView!

    @IBOutlet private var cnstrBottomContainerView: NSLayoutConstraint!
    @IBOutlet private var cnstrBottomEyeButton: NSLayoutConstraint!

    private var isFullScreenMode = false

    // ViewModel
    public var viewModel: ExampleItemViewModelProtocol!
    private let imageSaver = ImageSaver()

    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        analytics.logScreen(.examplesDetail)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        longTapTutorialView.start(withDelay: 1.5)
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
}

// MARK: - SetupUI
private extension ExampleDetailViewController {
    func setupUI() {
        view.backgroundColor = .white
        eyeButton.tintColor = .kPurple
        waterSignImageView.image = UIImage(named: "icWaterSign", in: Bundle.designSystem, compatibleWith: nil)
    
        if let urlBefore = URL(string: viewModel.imageBefore) {
            beforeAfterImagePresentableView.setBeforeImageURL(urlBefore)
        }
        if let urlAfter = URL(string: viewModel.imageAfter) {
            beforeAfterImagePresentableView.setAfterImageURL(urlAfter)
        }

        updateUI()
        updateEyeButton(isOpen: true)
    }

    func updateUI() {
        waterSignImageView.isHidden = viewModel.isPayed
        bottomContainerView.fill(
            viewModel: viewModel.makeImageInfoContainerViewModel())
    }

    func updateBottomConstraints(animated: Bool) {
        let constant = isFullScreenMode ? -bottomContainerView.frame.height - 44 : 16
        cnstrBottomContainerView.constant = constant
        cnstrBottomEyeButton.constant = isFullScreenMode ? 60 : 16
        if animated {
            UIView.animate(withDuration: 0.25)
                { self.view.layoutIfNeeded() }
        }
    }

    func updateEyeButton(isOpen: Bool) {
        let eyeImgString = isOpen ? "icEyeOpenPurple" : "icEyeClosePurple"
        let img = UIImage(named: eyeImgString, in: Bundle.designSystem, compatibleWith: nil)
        eyeButton.setImage(img, for: .normal)
    }
}


// MARK: - Actions
private extension ExampleDetailViewController {
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func eyeAction(_ sender: Any) {
        isFullScreenMode = !isFullScreenMode
        updateEyeButton(isOpen: !isFullScreenMode)
        updateBottomConstraints(animated: true)
        
        analytics.logAction(isFullScreenMode ? .showExamplesFullScreen : .showExamplesNotFullScreen)
    }
}
