//
//  GalleryAndPhotoView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 16.02.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem

protocol GalleryAndPhotoViewDelegate: AnyObject {
    func didTapGallery(from view: GalleryAndPhotoView)
    func didTapCamera(from view: GalleryAndPhotoView)
}

@objc(GalleryAndPhotoView)
final class GalleryAndPhotoView: BaseCustomView {
    // MARK: - Properties
    // UI
    @IBOutlet private var xibView: UIView!
    @IBOutlet private var galleryButton: UIButton!
    @IBOutlet private var cameraButton: UIButton!
    @IBOutlet private var separatorView: UIView!

    // Delegate
    weak var delegate: GalleryAndPhotoViewDelegate?

    // MARK: - initialize
    override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear

        xibView.backgroundColor = .kPurple
        xibView.layer.cornerRadius = 18
        xibView.layer.masksToBounds = true

        let galleryImg = UIImage(named: "icGallery", in: Bundle.designSystem, compatibleWith: nil)?
            .withRenderingMode(.alwaysOriginal)
        galleryButton.setImage(galleryImg, for: .normal)

        let cameraImg = UIImage(named: "icCamera", in: Bundle.designSystem, compatibleWith: nil)?
            .withRenderingMode(.alwaysOriginal)
        cameraButton.setImage(cameraImg, for: .normal)

        separatorView.backgroundColor = .white
    }
}

// MARK: - Actions
private extension GalleryAndPhotoView {
    @IBAction func galleryAction(_ sender: Any) {
        delegate?.didTapGallery(from: self)
    }

    @IBAction func cameraAction(_ sender: Any) {
        delegate?.didTapCamera(from: self)
    }
}
