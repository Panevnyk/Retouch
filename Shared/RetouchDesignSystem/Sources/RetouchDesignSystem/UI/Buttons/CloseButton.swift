//
//  CloseButton.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 14.02.2021.
//

import UIKit

public final class CloseButton: UIButton {
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
        let img = UIImage(named: "icClosePurple", in: Bundle.module, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
        setImage(img, for: .normal)
    }
}
