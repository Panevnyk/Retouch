//
//  StatusButton.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 24.02.2021.
//

import UIKit

public final class StatusButton: UIButton {
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
        layer.cornerRadius = 12
        layer.masksToBounds = true
        titleLabel?.font = .kPlainBoldText
        setTitleColor(.kPurple, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
