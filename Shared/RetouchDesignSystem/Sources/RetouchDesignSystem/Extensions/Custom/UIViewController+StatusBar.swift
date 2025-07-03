//
//  UIViewController+StatusBar.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 26.03.2021.
//

import UIKit

extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController?.childForStatusBarStyle ?? selectedViewController
    }
}

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController?.childForStatusBarStyle ?? topViewController
    }
}
