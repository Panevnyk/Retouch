//
//  BackButton1.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit

public final class BackButton1: UIButton {
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
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.masksToBounds = true
        setImage(UIImage(named: "icLeftArrowPurple", in: Bundle.module, compatibleWith: nil), for: .normal)
    }
}
