//
//  LongTapTutorialView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 16.02.2021.
//

import UIKit

@objc(LongTapTutorialView)
public final class LongTapTutorialView: BaseCustomView {
    @IBOutlet var xibView: UIView!
    @IBOutlet var imageView: UIImageView!

    private var isAlreadyStarted = false

    public override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)
        isUserInteractionEnabled = false
        backgroundColor = .clear
        xibView.backgroundColor = .white
        xibView.layer.cornerRadius = 37
        xibView.layer.masksToBounds = true
        xibView.alpha = 0
        xibView.isHidden = true

        imageView.image =
            UIImage(named: "icLongTap", in: Bundle.module, compatibleWith: nil)
    }

    public func start(withDelay delay: Double) {
        guard !isAlreadyStarted else { return }
        isAlreadyStarted = true
        self.xibView.isHidden = false

        animateAlpha(to: 1, delay: delay, options: [.curveEaseIn]) {
            self.animateBouncing(repeatCount: 5, isUp: true) {
                self.animateAlpha(to: 0, delay: 0, options: [.curveEaseOut]) {
                    self.xibView.isHidden = true
                }
            }
        }
    }

    private func animateAlpha(to alpha: CGFloat,
                              delay: Double,
                              options: UIView.AnimationOptions,
                              completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, delay: delay, options: options, animations: {
            self.xibView.alpha = alpha
        }, completion: { _ in completion?() })
    }

    private func animateBouncing(repeatCount: Int, isUp: Bool, completion: (() -> Void)?) {
        let scale: CGFloat = isUp ? 1.2 : 1
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)

        }, completion: { _ in
            if repeatCount == 0 {
                completion?()
            } else {
                self.animateBouncing(repeatCount: repeatCount - 1, isUp: !isUp, completion: completion)
            }
        })
    }
}
