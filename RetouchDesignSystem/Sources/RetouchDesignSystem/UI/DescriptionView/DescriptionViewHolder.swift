//
//  DescriptionViewHolder.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 18.04.2022.
//

import UIKit

public class DescriptionViewHolder: BaseTapableView {
    // MARK: - Properties
    private var activeDescriptionView: DescriptionView!
    
    private var leadingConstraint: NSLayoutConstraint?
    
    private var placeholderText = ""
    
    public override var delegate: BaseTapableViewDelegate? {
        get { activeDescriptionView.delegate }
        set { activeDescriptionView.delegate = newValue }
    }
    
    // MARK: - initialize
    public override func initialize() {
        super.initialize()
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        activeDescriptionView = createDescriptionView()
        activeDescriptionView.delegate = delegate
        addSubview(activeDescriptionView)
        leadingConstraint = activeDescriptionView.leadingAnchor.constraint( equalTo: leadingAnchor, constant: 0)
        NSLayoutConstraint.activate([
            leadingConstraint!,
            activeDescriptionView.topAnchor.constraint(equalTo: topAnchor),
            activeDescriptionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            activeDescriptionView.widthAnchor.constraint(equalTo: widthAnchor, constant: 0)
        ])
    }
    
    func createDescriptionView() -> DescriptionView {
        let view = DescriptionView()
        view.setPlaceholderText(placeholderText)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    // MARK: - Public methods
    public func setPlaceholderText(_ text: String) {
        placeholderText = text
        activeDescriptionView.setPlaceholderText(text)
    }
    
    public func setText(_ text: String) {
        activeDescriptionView.setText(text)
    }
    
    public func move(to moveDirection: MoveDirection, text: String) {
        let view = createDescriptionView()
        view.delegate = delegate
        view.setText(text)
        addSubview(view)
        let leading = view.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: moveDirection == .toLeft
                ? activeDescriptionView.frame.width + 16
                : -activeDescriptionView.frame.width - 16)
        NSLayoutConstraint.activate([
            leading,
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.widthAnchor.constraint(equalTo: widthAnchor, constant: 0)
        ])
        self.layoutIfNeeded()
        
        leading.constant = 0
        leadingConstraint?.constant = moveDirection == .toLeft
            ? -activeDescriptionView.frame.width - 16
            : activeDescriptionView.frame.width + 16
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.activeDescriptionView.removeFromSuperview()
            self.leadingConstraint = leading
            self.activeDescriptionView = view
        }
    }
}

public enum MoveDirection {
    case toRight
    case toLeft
}
