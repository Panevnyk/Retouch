//
//  ImagePresentableView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit
import RetouchUtils
import FactoryKit

public protocol ImagePresentableViewDelegate: AnyObject {
    @MainActor
    func scrollViewDidScroll(_ scrollView: UIScrollView, from view: UIView)
}

@objc(ImagePresentableView)
public final class ImagePresentableView: BaseCustomView {
    // MARK: - Properties
    @Injected(\.imageLoader) public var imageLoader
    
    @IBOutlet public var xibView: UIView!
    @IBOutlet public var containerVIew: UIView!
    @IBOutlet public var scrollView: UIScrollView!
    @IBOutlet public var scrollContainerView: UIView!
    @IBOutlet public var imageView: UIImageView!
    
    public weak var delegate: ImagePresentableViewDelegate?

    // MARK: - initialize
    public override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)
        setupUI()
    }

    // MARK: - Public methods
    public func setImage(_ image: UIImage?) {
        imageView.image = image
    }

    public func setImageURL(_ url: URL) {
        imageLoader.setImage(to: imageView, from: url)
    }
}

// MARK: - SetupUI
private extension ImagePresentableView {
    func setupUI() {
        backgroundColor = .clear

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }

        scrollView.contentOffset = .zero
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0

        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(doubleTapScrollViewAction))
        doubleTapGest.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGest)
    }
}

// MARK: - Actions
private extension ImagePresentableView {
    @objc func doubleTapScrollViewAction(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            let zoomRect = zoomRectForScale(
                scale: scrollView.maximumZoomScale,
                center: recognizer.location(in: recognizer.view))
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

// MARK: - UIScrollViewDelegate
extension ImagePresentableView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollContainerView
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView, from: self)
    }
}
