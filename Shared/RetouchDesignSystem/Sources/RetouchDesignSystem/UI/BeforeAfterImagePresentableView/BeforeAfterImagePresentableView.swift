//
//  BeforeAfterView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit

public final class BeforeAfterImagePresentableView: BaseCustomView {
    // MARK: - UI
    public let beforeImagePresentableView = ImagePresentableView()
    public let afterImagePresentableView = ImagePresentableView()

    // MARK: - Data
    private var isAfter = true

    // MARK: - Init
    public override func initialize() {
        setupUI()
        setupGesture()
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        [beforeImagePresentableView, afterImagePresentableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.imageView.contentMode = .scaleAspectFill
            addSubview($0)
        }

        // Layout: both views should cover full area
        NSLayoutConstraint.activate([
            beforeImagePresentableView.topAnchor.constraint(equalTo: topAnchor),
            beforeImagePresentableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            beforeImagePresentableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            beforeImagePresentableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            afterImagePresentableView.topAnchor.constraint(equalTo: topAnchor),
            afterImagePresentableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            afterImagePresentableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            afterImagePresentableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        afterImagePresentableView.alpha = 1
        beforeImagePresentableView.alpha = 0

        afterImagePresentableView.delegate = self
    }

    private func setupGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.1
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        afterImagePresentableView.scrollView.addGestureRecognizer(longPress)
    }

    // MARK: - Public methods
    public func setBeforeImage(_ image: UIImage?) {
        beforeImagePresentableView.setImage(image)
    }

    public func setAfterImage(_ image: UIImage?) {
        afterImagePresentableView.setImage(image)
    }

    public func setBeforeImageURL(_ url: URL) {
        beforeImagePresentableView.setImageURL(url)
    }

    public func setAfterImageURL(_ url: URL) {
        afterImagePresentableView.setImageURL(url)
    }
}

// MARK: - ImagePresentableViewDelegate
extension BeforeAfterImagePresentableView: ImagePresentableViewDelegate {
    @MainActor
    public func scrollViewDidScroll(_ scrollView: UIScrollView, from view: UIView) {
        beforeImagePresentableView.scrollView.zoomScale = scrollView.zoomScale
        beforeImagePresentableView.scrollView.contentOffset = scrollView.contentOffset
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BeforeAfterImagePresentableView: UIGestureRecognizerDelegate {
    @objc private func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != .ended {
            if isAfter {
                isAfter = false
                afterImagePresentableView.alpha = 0
                beforeImagePresentableView.alpha = 1
            }
        } else {
            if !isAfter {
                isAfter = true
                afterImagePresentableView.alpha = 1
                beforeImagePresentableView.alpha = 0
            }
        }
    }
}
