//
//  RTAlertAction.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 07.04.2021.
//

import UIKit

public enum RTAlertActionStyle {
    case `default`
    case cancel
}

public final class RTAlertAction: StateBackgroundColorButton {
    private var action: (() -> Void)?
    private var style: RTAlertActionStyle = .default

    public init() {
        super.init(frame: CGRect.zero)
        self.addTarget(self, action: #selector(actionTrigger), for: .touchUpInside)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    public convenience init(title: String?, style: RTAlertActionStyle, action: (() -> Void)? = nil) {
        self.init()

        self.setTitle(title, for: .normal)
        self.style = style
        self.action = action

        setupUI()
    }

    public convenience init(title: String?, action: (() -> Void)?) {
        self.init(title: title, style: .default, action: nil)
    }

    public convenience init(title: String?) {
        self.init(title: title, action: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc public func actionTrigger() {
        self.action?()
    }

    private func setupUI() {
        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.cornerRadius = 6
        titleLabel?.font = .kTitleText

        let titleColor: UIColor
        let borderColor: CGColor
        let backgroundColor: UIColor

        switch style {
        case .default:
            titleColor = .white
            borderColor = UIColor.white.cgColor
            backgroundColor = .kPurple
        case .cancel:
            titleColor = .kPurple
            borderColor = UIColor.kSeparatorGray.cgColor
            backgroundColor = .white
        }

        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.backgroundDisabledColor = backgroundColor.withAlphaComponent(0.3)
        layer.borderColor = borderColor
    }
}

