//
//  UIStackView+RemoveAllArrangeSubviews.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 19.03.2021.
//

import UIKit

public extension UIStackView {
    func removeAllArrangeSubviews() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
