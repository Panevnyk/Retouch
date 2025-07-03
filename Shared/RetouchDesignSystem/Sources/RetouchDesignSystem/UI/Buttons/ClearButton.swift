//
//  ClearButton.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 07.05.2021.
//

import UIKit

public final class ClearButton: UIButton {
    // Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initCustomize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCustomize()
    }

    // Customize
    private func initCustomize() {
        backgroundColor = .clear
        layer.cornerRadius = 6
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        setTitleColor(.white, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
