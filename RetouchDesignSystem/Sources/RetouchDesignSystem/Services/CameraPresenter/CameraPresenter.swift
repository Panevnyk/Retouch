//
//  CameraPresenter.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 17.02.2021.
//

import UIKit
import AVFoundation

@MainActor
public protocol CameraPresenterDelegate: AnyObject {
    func didSelectPhoto(image: UIImage)
    func dismiss(picker: UIImagePickerController)
}

@MainActor
public protocol CameraPresenterProtocol {
    var delegate: CameraPresenterDelegate? { get set }
    
    func presentCamera(from viewController: UIViewController)
}

@MainActor
public final class CameraPresenter: NSObject, @preconcurrency CameraPresenterProtocol {
    public override init() {}

    public weak var delegate: CameraPresenterDelegate?

    public func presentCamera(from viewController: UIViewController) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

        if authStatus == .authorized {
            presentAuthorizedCamera(from: viewController)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (granted: Bool) in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    if granted {
                        self.presentAuthorizedCamera(from: viewController)
                    } else {
                        self.presentNotAccessToCameraAlert()
                    }
                }
            })
        }
    }

    private func presentAuthorizedCamera(from viewController: UIViewController) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.delegate = self
        viewController.present(pickerController, animated: true)
    }

    private func presentNotAccessToCameraAlert() {
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        let goToSettingsAction = UIAlertAction(
            title: "Open Settings",
            style: .default,
            handler: { _ in
                SettingsHelper.openSettings()
            })
        AlertHelper.show(title: "No access to camera",
                         message: "To enable access please go to your device setting",
                         alertActions: [cancelAction, goToSettingsAction])
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CameraPresenter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.dismiss(picker: picker)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        delegate?.dismiss(picker: picker)

        guard let image = info[.originalImage] as? UIImage else { return }
        delegate?.didSelectPhoto(image: image)
    }
}
