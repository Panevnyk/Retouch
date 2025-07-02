//
//  UIApplication+KeyWindow.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 09.07.2021.
//

import UIKit

extension UIApplication {
    static var keyWindow: UIWindow? {
        return shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
}
