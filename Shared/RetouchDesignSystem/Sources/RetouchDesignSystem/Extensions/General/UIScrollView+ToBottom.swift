//
//  UIScrollView+ToBottom.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 11.02.2021.
//

import UIKit

public extension UIScrollView {
    func scrollToBottom(isAnimated: Bool) {
        let rect = CGRect(x: 0,
                          y: contentSize.height - bounds.size.height,
                          width: bounds.size.width,
                          height: bounds.size.height)
        scrollRectToVisible(rect, animated: isAnimated)
    }
}
