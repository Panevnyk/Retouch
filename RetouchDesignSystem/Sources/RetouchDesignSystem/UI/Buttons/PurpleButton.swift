//
//  OrderButton.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit

public final class PurpleButton: StateBackgroundColorButton {
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
        backgroundColor = .kPurple
        backgroundDisabledColor = .kNotActivePurple
        layer.cornerRadius = 6
        layer.masksToBounds = true
        setTitleColor(.white, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
