//
//  UIView+Shadow.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 19.11.2020.
//

import UIKit

public extension UIView {
    func addContainerTopShadow() {
        layer.shadowColor = UIColor.kTextMiddleGray30.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: -4)
    }
    
    func addBottomContainerShadow() {
        layer.shadowColor = UIColor.kGrayText.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    // ----------
    
    func addContainerShadow() {
        layer.shadowColor = UIColor.kBlueyGrey30.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    func addBottomShadow() {
        layer.shadowColor = UIColor.kLightBlueGrey53.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    func addTopShadow() {
        layer.shadowColor = UIColor.kBlueyGrey30.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: -2)
    }

    func clearShadow() {
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
    }
}
