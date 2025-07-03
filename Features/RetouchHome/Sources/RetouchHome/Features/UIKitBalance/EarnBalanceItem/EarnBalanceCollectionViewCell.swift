//
//  EarnBalanceCollectionViewCell.swift
//  RetouchHome
//
//  Created by Panevnyk Vlad on 11.07.2022.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem

final class EarnBalanceCollectionViewCell: UICollectionViewCell {
    // MARK: - Views
    private let containerView = UIView()
    private let priceView = PriceView()
    private let bottomContainerView = UIView()
    private let descriptionLabel = UILabel()

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
        containerView.addSubview(priceView)

        NSLayoutConstraint.activate([
            priceView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            priceView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 22),
            priceView.heightAnchor.constraint(equalToConstant: 20)
        ])

        // Bottom Container View
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.backgroundColor = .kPurple
        containerView.addSubview(bottomContainerView)

        NSLayoutConstraint.activate([
            bottomContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            bottomContainerView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5)
        ])

        // Description Label
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .kPlainText
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2
        bottomContainerView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor)
        ])
    }

    // MARK: - Public
    func fill(viewModel: EarnBalanceItemViewModelProtocol) {
        priceView.setPrice(viewModel.diamondPrice)
        descriptionLabel.text = viewModel.descriptionTitle
        containerView.alpha = viewModel.isAvailable ? 1 : 0.3
        contentView.superview?.isUserInteractionEnabled = viewModel.isAvailable
    }
}
