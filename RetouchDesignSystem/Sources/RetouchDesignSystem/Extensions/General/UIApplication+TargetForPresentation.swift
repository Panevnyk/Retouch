//
//  UIApplication+TargetForPresentation.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 11.11.2020.
//

import UIKit

extension UIApplication {
    class var presentingViewController: UIViewController? {
        var targetForPresent = UIApplication.keyWindow?.rootViewController

        while targetForPresent?.presentedViewController != nil {
            targetForPresent = targetForPresent?.presentedViewController
        }

        return targetForPresent
    }
}
