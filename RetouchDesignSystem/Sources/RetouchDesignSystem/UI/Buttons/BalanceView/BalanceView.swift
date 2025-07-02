//
//  BalanceView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 12.02.2021.
//

import UIKit

public protocol BalanceViewDelegate: AnyObject {
    @MainActor
    func didTapAction(from view: BalanceView)
}

public final class BalanceView: BaseTapableView {
    // MARK: - UI Elements
    private let balanceLabel = UILabel()
    private let balanceImageView = UIImageView()
    private let stackView = UIStackView()

    public weak var balanceDelegate: BalanceViewDelegate?

    // MARK: - Initialize
    public override func initialize() {
        super.initialize()
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        delegate = self
        backgroundColor = .clear
        layer.cornerRadius = 16
        isUserInteractionEnabled = true
        layer.masksToBounds = true
        layer.borderWidth = 1

        balanceLabel.font = .kPlainBigText
//        balanceLabel.isUserInteractionEnabled = true
        balanceLabel.text = "0"

        balanceImageView.contentMode = .scaleAspectFit
//        balanceImageView.isUserInteractionEnabled = true
        balanceImageView.image = UIImage(
            named: "icDiamondPurple",
            in: Bundle.module,
            compatibleWith: nil
        )?.withRenderingMode(.alwaysTemplate)

        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(balanceLabel)
        stackView.addArrangedSubview(balanceImageView)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 32),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13)
        ])

        setColor(.kPurple)
    }

    // MARK: - Public API
    public func setBalance(_ value: Int) {
        balanceLabel.text = "\(value)"
    }

    public func setColor(_ color: UIColor) {
        balanceLabel.textColor = color
        layer.borderColor = color.cgColor
        balanceImageView.tintColor = color
    }
}

// MARK: - BaseTapableViewDelegate
extension BalanceView: BaseTapableViewDelegate {
    public func didTapAction(inView view: BaseTapableView) {
        balanceDelegate?.didTapAction(from: self)
    }
}
