//
//  OrderDetailViewController.swift
//  RetouchHome
//
//  Created by Panevnyk Vlad on 05.07.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

@objc(OrderDetailViewController)
public final class OrderDetailViewController: UIViewController {
    // MARK: - Properties
    @Injected(\.analytics) private var analytics
    @Injected(\.notificationBanner) private var notificationBanner
    
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
    public var viewModel: OrderDetailViewModelProtocol!
    private let imageSaver = ImageSaver()

    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        analytics.logScreen(.orderDetail)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        longTapTutorialView.start(withDelay: 1.5)
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
}

// MARK: - SetupUI
private extension OrderDetailViewController {
    func setupUI() {
        view.backgroundColor = .white
        eyeButton.tintColor = .kPurple
        waterSignImageView.image = UIImage(named: "icWaterSign", in: Bundle.designSystem, compatibleWith: nil)

        if let beforeURL = URL(string: viewModel.imageBefore) {
            beforeAfterImagePresentableView.setBeforeImageURL(beforeURL)
        }
        if let afterURL = URL(string: viewModel.imageAfter) {
            beforeAfterImagePresentableView.setAfterImageURL(afterURL)
        }

        bottomContainerView.delegate = self

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

// MARK: - ImageInfoContainerViewDelegate
extension OrderDetailViewController: ImageInfoContainerViewDelegate {
    public func didTapRemoveOrder(from view: ImageInfoContainerView) {
        let removeAction = UIAlertAction(title: "Remove", style: .default) { [weak self] _ in
            self?.removeOrder()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        AlertHelper.show(title: "Do you really want to remove order?",
                         message: nil,
                         alertActions: [removeAction, cancelAction])
    }
    
    @objc func removeOrder() {
        Task {
            if await viewModel.removeOrder() {
                notificationBanner.show(title: "Order was removed successfully", style: .success)
                backAction()
            }
        }
    }
    
    public func didTapRatingOrder(from view: ImageInfoContainerView) {
        Task {
            await viewModel.requestReview(force: true)
        }
    }
    
    public func didTapDownload(from view: ImageInfoContainerView) {
        Task {
            analytics.logAction(.download)
            ActivityIndicatorHelper.shared.show()
            let isSuccess = await imageSaver.writeToPhotoAlbum(imageURLString: self.viewModel.imageAfter)
            ActivityIndicatorHelper.shared.hide()
            if isSuccess {
                notificationBanner.show(title: "Photo saved to Camera Roll", style: .success)
                do {
                    try await Task.sleep(nanoseconds: 5_000_000_000)
                } catch {}
                await viewModel.requestReview(force: false)
            }
        }
    }
    
    public func didTapShare(from view: ImageInfoContainerView) {
        analytics.logAction(.share)
        ShareHelper.share(self.viewModel.imageAfter, from: self)
    }
    
    public func didTapRedo(from view: ImageInfoContainerView) {
        let alertVC = UIAlertController(
            title: "Send for redesign to designers",
            message: "Please, write what you would like to change of current retouching (at least 4 digits)",
            preferredStyle: .alert)

        let send = UIAlertAction(title: "Send", style: .default, handler: { [weak self] _ in
            if let redoDescription = alertVC.textFields?.first?.text, redoDescription.count > 3 {
                self?.sendForRedo(redoDescription: redoDescription)
            } else {
                AlertHelper.show(title: "Redo message should contain at least 4 digits", message: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertVC.addTextField(configurationHandler: { (textField) in
            textField.keyboardType = .default
            textField.delegate = self
        })

        alertVC.addAction(cancel)
        alertVC.addAction(send)

        present(alertVC, animated: true, completion: nil)
    }

    private func sendForRedo(redoDescription: String) {
        Task {
            analytics.logAction(.redo)
            
            ActivityIndicatorHelper.shared.show()
            let isSuccess = await viewModel.sendForRedo(redoDescription: redoDescription)
            
            ActivityIndicatorHelper.shared.hide()
            if isSuccess {
                notificationBanner.show(title: "Image was sent for redesign successfully", style: .success)
                backAction(backButton as Any)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension OrderDetailViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.becomeFirstResponder()
        return true
    }
}

// MARK: - Actions
private extension OrderDetailViewController {
    @IBAction func backAction(_ sender: Any) {
        backAction()
    }
    
    private func backAction() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func eyeAction(_ sender: Any) {
        isFullScreenMode = !isFullScreenMode
        updateEyeButton(isOpen: !isFullScreenMode)
        updateBottomConstraints(animated: true)
       
        analytics.logAction(isFullScreenMode ? .showOrderFullScreen : .showOrderNotFullScreen)
    }
}
