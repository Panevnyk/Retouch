//
//  SubscriptionBalanceCollectionViewCell.swift
//  RetouchHome
//
//  Created by Panevnyk Vlad on 11.07.2022.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem

final class SubscriptionBalanceCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    private let containerView = UIView()
    private let priceView = PriceView()
    private let usdPriceContainerView = UIView()
    private let usdPriceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stackView = UIStackView()

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

        // Stack View (Vertical)
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        // Price View
        priceView.translatesAutoresizingMaskIntoConstraints = false
        priceView.setPriceFont(.kPlainBigText)
        priceView.backgroundColor = .kPurple
        stackView.addArrangedSubview(priceView)

        NSLayoutConstraint.activate([
            priceView.heightAnchor.constraint(equalToConstant: 20),
            priceView.widthAnchor.constraint(equalToConstant: 100)
        ])

        // Description Label
        descriptionLabel.font = .kPlainText
        descriptionLabel.textColor = .kTextDarkGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 1
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(descriptionLabel)

        // USD Price Container View
        usdPriceContainerView.translatesAutoresizingMaskIntoConstraints = false
        usdPriceContainerView.backgroundColor = .kPurple
        containerView.addSubview(usdPriceContainerView)

        NSLayoutConstraint.activate([
            usdPriceContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            usdPriceContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            usdPriceContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            usdPriceContainerView.widthAnchor.constraint(equalToConstant: 53.5) // fixed from XIB
        ])

        // USD Price Label
        usdPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        usdPriceLabel.font = .kTitleText
        usdPriceLabel.textColor = .white
        usdPriceLabel.textAlignment = .center
        usdPriceLabel.numberOfLines = 0
        usdPriceContainerView.addSubview(usdPriceLabel)

        NSLayoutConstraint.activate([
            usdPriceLabel.leadingAnchor.constraint(equalTo: usdPriceContainerView.leadingAnchor, constant: 6),
            usdPriceLabel.trailingAnchor.constraint(equalTo: usdPriceContainerView.trailingAnchor, constant: -6),
            usdPriceLabel.topAnchor.constraint(equalTo: usdPriceContainerView.topAnchor),
            usdPriceLabel.bottomAnchor.constraint(equalTo: usdPriceContainerView.bottomAnchor)
        ])
    }

    // MARK: - Public
//    func fill(viewModel: BalanceItemViewModelProtocol) {
//        priceView.setPrice(viewModel.diamondPrice)
//        usdPriceLabel.text = viewModel.usdPrice
//        bonusesLabel.text = viewModel.bonuses
//    }
}
