//
//  BalanceCollectionViewCell.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 17.02.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem

final class BalanceCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    private let containerView = UIView()
    private let priceView = PriceView()
    private let bottomContainerView = UIView()
    private let usdPriceLabel = UILabel()
    private let bonusesLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.backgroundColor = .clear

        // Container View
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // Price View
        priceView.translatesAutoresizingMaskIntoConstraints = false
        priceView.backgroundColor = .kPurple
        containerView.addSubview(priceView)

        NSLayoutConstraint.activate([
            priceView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 19),
            priceView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            priceView.heightAnchor.constraint(equalToConstant: 20),
            priceView.widthAnchor.constraint(equalToConstant: 100)
        ])

        // Bonuses Label
        bonusesLabel.translatesAutoresizingMaskIntoConstraints = false
        bonusesLabel.font = .kPlainText
        bonusesLabel.textColor = .kTextDarkGray
        bonusesLabel.textAlignment = .center
        containerView.addSubview(bonusesLabel)

        NSLayoutConstraint.activate([
            bonusesLabel.topAnchor.constraint(equalTo: priceView.bottomAnchor, constant: 92),
            bonusesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bonusesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bonusesLabel.heightAnchor.constraint(equalToConstant: 20.5)
        ])

        // Bottom Container View (with usdPriceLabel inside)
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.backgroundColor = .kPurple
        containerView.addSubview(bottomContainerView)

        NSLayoutConstraint.activate([
            bottomContainerView.topAnchor.constraint(equalTo: bonusesLabel.bottomAnchor, constant: 4),
            bottomContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 32)
        ])

        // USD Price Label
        usdPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        usdPriceLabel.font = .kTitleText
        usdPriceLabel.textColor = .white
        usdPriceLabel.textAlignment = .center
        bottomContainerView.addSubview(usdPriceLabel)

        NSLayoutConstraint.activate([
            usdPriceLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            usdPriceLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor),
            usdPriceLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            usdPriceLabel.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor)
        ])
    }

    // MARK: - Public
    func fill(viewModel: BalanceItemViewModelProtocol) {
        priceView.setPrice(viewModel.diamondPrice)
        usdPriceLabel.text = viewModel.usdPrice
        bonusesLabel.text = viewModel.bonuses
    }
}
