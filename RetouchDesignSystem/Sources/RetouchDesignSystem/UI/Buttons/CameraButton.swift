//
//  PhotoButton.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 17.02.2021.
//

import UIKit

public final class CameraButton: UIButton {
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
        layer.cornerRadius = 18
        layer.masksToBounds = true
        let cameraImg = UIImage(named: "icCamera", in: Bundle.module, compatibleWith: nil)?
            .withRenderingMode(.alwaysOriginal)
        setImage(cameraImg, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
}
