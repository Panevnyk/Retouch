//
//  RedoButton.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 24.02.2021.
//

import UIKit

public final class RedoButton: UIButton {
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
        layer.cornerRadius = 6
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.kGrayText.cgColor
        backgroundColor = .white
        titleLabel?.font = .kPlainBoldText
        setTitle("Redo", for: .normal)
        setTitleColor(.kPurple, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
