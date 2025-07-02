//
//  StarButton.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 29.04.2021.
//

import UIKit

public final class StarButton: UIButton {
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
        tintColor = .clear
        
        let starImg = UIImage(named: "icStar", in: Bundle.module, compatibleWith: nil)?
            .withRenderingMode(.alwaysOriginal)
        let starSelectedImg = UIImage(named: "icStarSelected", in: Bundle.module, compatibleWith: nil)?
            .withRenderingMode(.alwaysOriginal)
        setImage(starImg, for: .normal)
        setImage(starSelectedImg, for: .selected)
    }
}
