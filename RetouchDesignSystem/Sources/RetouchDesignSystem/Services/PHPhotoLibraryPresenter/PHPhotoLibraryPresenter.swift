//
//  PHPhotoLibraryPresenter.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 17.02.2021.
//

import UIKit
import Photos

@MainActor 
public protocol PHPhotoLibraryPresenterProtocol {
    func requestPhotosAuthorization() async -> Bool
    func presentNotAccessToPhotoLibraryAlert()
}

@MainActor
public final class PHPhotoLibraryPresenter: PHPhotoLibraryPresenterProtocol {
    public init() {}

    public func requestPhotosAuthorization() async -> Bool {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            let result = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return result == .authorized
        } else if photos == .authorized {
            return true
        } else {
            return false
        }
    }

    public func presentNotAccessToPhotoLibraryAlert() {
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
        AlertHelper.show(title: "No access to photo library",
                         message: "To enable access please go to your device setting",
                         alertActions: [cancelAction, goToSettingsAction])
    }
}

