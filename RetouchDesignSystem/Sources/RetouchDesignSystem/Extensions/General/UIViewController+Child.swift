//
//  UIView+Child.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 12.02.2021.
//

import UIKit

public extension UIViewController {
    func addChild(_ viewController: UIViewController, onView view: UIView) {
        addChild(viewController)
        view.addSubviewUsingConstraints(view: viewController.view)
        viewController.didMove(toParent: self)
    }

    func removeFromParentViewController() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
