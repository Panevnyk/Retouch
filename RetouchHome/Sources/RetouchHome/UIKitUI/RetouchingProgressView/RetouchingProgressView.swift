//
//  RetouchingProgressView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 14.02.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem

@objc(RetouchingProgressView)
final class RetouchingProgressView: BaseCustomView {
    // MARK: - Properties
    @IBOutlet private var xibView: UIView!
    @IBOutlet private var topStackView: UIStackView!
    @IBOutlet private var bottomStackView: UIStackView!
    @IBOutlet private var gradientView: UIView!
    @IBOutlet private var grayView: UIView!

    @IBOutlet private var cnstrLeadingGrayView: NSLayoutConstraint!

    private var activeIndex = 0
    private var states: [String] = []

    // MARK: - initialize
    override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)

        backgroundColor = .clear

        gradientView.layer.cornerRadius = 3
        gradientView.layer.masksToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.kPurple.cgColor, UIColor.kPurple.cgColor, UIColor.kBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        grayView.backgroundColor = .kSeparatorGray
    }

    func fill(states: [String], activeIndex: Int) {
        self.states = states

        let viewWidth = UIScreen.main.bounds.width - 32
        let sliceWidth = viewWidth / CGFloat(states.count)

        setActiveIndex(activeIndex: activeIndex, animated: false)

        for i in 0 ..< states.count {
            let state = states[i]
            let isPair = i % 2 == 0
            let emptyLabel = makeLabel(text: "")
            let titledLabel = makeLabel(text: state)

            topStackView.addArrangedSubview(isPair ? emptyLabel : titledLabel)
            bottomStackView.addArrangedSubview(isPair ? titledLabel : emptyLabel)

            if i != 0 {
                addSeparatorView(leadingSpace: CGFloat(i) * sliceWidth)
            }
        }
    }

    func setActiveIndex(activeIndex: Int, animated: Bool) {
        self.activeIndex = activeIndex
        let viewWidth = UIScreen.main.bounds.width - 32
        let sliceWidth = viewWidth / CGFloat(states.count)
        let space = sliceWidth * CGFloat(activeIndex)

        cnstrLeadingGrayView.constant = space
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) {
                self.layoutIfNeeded()
            } completion: { _ in }
        }
    }

    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .kDescriptionText
        label.textColor = .kGrayText
        label.text = text
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }

    private func addSeparatorView(leadingSpace: CGFloat) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        gradientView.addSubview(view)

        view.heightAnchor.constraint(equalToConstant: 6).isActive = true
        view.widthAnchor.constraint(equalToConstant: 2).isActive = true
        view.topAnchor.constraint(equalTo: gradientView.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: leadingSpace).isActive = true
    }
}
