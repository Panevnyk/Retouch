//
//  BaseTapableView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 02.12.2020.
//

import UIKit

public protocol BaseTapableViewDelegate: AnyObject {
    @MainActor
    func didTapAction(inView view: BaseTapableView)
}

public class BaseTapableView: BaseCustomView {
    // Delegates
    public weak var delegate: BaseTapableViewDelegate?

    // initialize
    public override func initialize() {
        super.initialize()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        delegate?.didTapAction(inView: self)
    }
}
