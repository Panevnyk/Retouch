//
//  BuyView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 24.02.2021.
//

import UIKit

public protocol BuyViewDelegate: AnyObject {
    func didTapAction(from view: BuyView)
}

@objc(BuyView)
final public class BuyView: BaseCustomView {
    // MARK: - Properties
    @IBOutlet private var xibView: BaseTapableView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var balanceImageView: UIImageView!

    public weak var delegate: BuyViewDelegate?

    // MARK: - initialize
    public override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)

        xibView.delegate = self

        backgroundColor = .kPurple
        layer.cornerRadius = 6
        layer.masksToBounds = true

        balanceLabel.font = .kPlainBigText
        balanceLabel.textColor = .white

        balanceImageView.tintColor = .white
        balanceImageView.image =
            UIImage(named: "icDiamondPurple", in: Bundle.module, compatibleWith: nil)?
                .withRenderingMode(.alwaysTemplate)

    }

    public func setTitle(_ text: String) {
        balanceLabel.text = text
    }
}

// MARK: - BaseTapableViewDelegate
extension BuyView: BaseTapableViewDelegate {
    public func didTapAction(inView view: BaseTapableView) {
        delegate?.didTapAction(from: self)
    }
}
