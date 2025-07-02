//
//  MoreActionButton.swift
//  RetouchMore
//
//  Created by Vladyslav Panevnyk on 08.03.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem

final class MoreActionButton: BaseCustomView {
    // MARK: - UI Components
    let xibView = BaseTapableView()
    let actionImageView = UIImageView()
    let actionTitle = UILabel()
    let rightArrowImageView = UIImageView()

    // MARK: - Delegation
    var delegate: BaseTapableViewDelegate? {
        get { xibView.delegate }
        set { xibView.delegate = newValue }
    }

    // MARK: - Init
    override func initialize() {
        setupUI()
        setupLayout()
    }

    private func setupUI() {
        backgroundColor = .clear

        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.layer.cornerRadius = 6
        xibView.layer.masksToBounds = true
        xibView.layer.borderWidth = 1
        xibView.layer.borderColor = UIColor.kSeparatorGray.cgColor
        xibView.backgroundColor = .white

        actionImageView.translatesAutoresizingMaskIntoConstraints = false
        actionImageView.contentMode = .scaleAspectFit
        actionImageView.setContentHuggingPriority(.required, for: .horizontal)
        actionImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        actionTitle.translatesAutoresizingMaskIntoConstraints = false
        actionTitle.font = .kPlainText
        actionTitle.textColor = .black
        actionTitle.numberOfLines = 1

        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        rightArrowImageView.contentMode = .scaleAspectFit
        rightArrowImageView.setContentHuggingPriority(.required, for: .horizontal)
        rightArrowImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        rightArrowImageView.image = UIImage(named: "icRightArrowGray", in: Bundle.designSystem, compatibleWith: nil)

        addSubview(xibView)
        xibView.addSubview(actionImageView)
        xibView.addSubview(actionTitle)
        xibView.addSubview(rightArrowImageView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            xibView.topAnchor.constraint(equalTo: topAnchor),
            xibView.leadingAnchor.constraint(equalTo: leadingAnchor),
            xibView.trailingAnchor.constraint(equalTo: trailingAnchor),
            xibView.bottomAnchor.constraint(equalTo: bottomAnchor),

            actionImageView.centerYAnchor.constraint(equalTo: xibView.centerYAnchor),
            actionImageView.leadingAnchor.constraint(equalTo: xibView.leadingAnchor, constant: 16),
            actionImageView.widthAnchor.constraint(equalToConstant: 20),
            actionImageView.heightAnchor.constraint(equalToConstant: 20),

            actionTitle.centerYAnchor.constraint(equalTo: xibView.centerYAnchor),
            actionTitle.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 16),

            rightArrowImageView.centerYAnchor.constraint(equalTo: xibView.centerYAnchor),
            rightArrowImageView.leadingAnchor.constraint(equalTo: actionTitle.trailingAnchor, constant: 8),
            rightArrowImageView.trailingAnchor.constraint(equalTo: xibView.trailingAnchor, constant: -12),
            rightArrowImageView.widthAnchor.constraint(equalToConstant: 16),
            rightArrowImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    // MARK: - Public API
    public func setTitle(_ text: String) {
        actionTitle.text = text
    }

    public func setImage(_ imageName: String) {
        actionImageView.image = UIImage(named: imageName, in: Bundle.designSystem, compatibleWith: nil)
    }
}
