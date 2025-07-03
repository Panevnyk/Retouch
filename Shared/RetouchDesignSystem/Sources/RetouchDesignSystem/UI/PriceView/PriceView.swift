//
//  PriceView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit

@objc(PriceView)
public final class PriceView: BaseCustomView {
    // MARK: - Properties
    @IBOutlet public var xibView: UIView!
    @IBOutlet public var stackView: UIStackView!
    @IBOutlet public var priceLabel: UILabel!
    @IBOutlet public var currencyImageView: UIImageView!

    // MARK: - initialize
    public override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)

        backgroundColor = .clear

        priceLabel.font = .kPlainText
        priceLabel.textColor = .kPurple

        currencyImageView.image = UIImage(named: "icDiamondPurple", in: Bundle.module, compatibleWith: nil)
    }

    public func setPriceFont(_ font: UIFont) {
        priceLabel.font = font
    }

    public func setPrice(_ text: String) {
        priceLabel.text = text
    }
}
