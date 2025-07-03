//
//  ToastView.swift
//  Findd
//
//  Created by Panevnyk Vlad on 8/29/18.
//  Copyright © 2018 Anton Voropaev. All rights reserved.
//

import UIKit

@objc(ToastView)
final class ToastView: BaseTapableView, DetailAnimable {
    /// UI
    @IBOutlet private var xibView: UIView!
    @IBOutlet private var messageLabel: UILabel!
    
    private class var backgroundColor: UIColor {
        return .kInputBackgroundGrey
    }
    
    private class var textColor: UIColor {
        return .black
    }
    
    /// initialize
    override func initialize() {
        super.initialize()
        addSelfNibUsingConstraints(bundle: Bundle.module)
        setupUI()
    }
    
    private func setupUI() {
        delegate = self
        
        alpha = 0
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        xibView.backgroundColor = ToastView.backgroundColor
        backgroundColor = ToastView.backgroundColor
        messageLabel.backgroundColor = ToastView.backgroundColor
        
        messageLabel.textColor = ToastView.textColor
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    func show(message: String) {
        messageLabel.text = message
        showView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        hideView { [weak self] in
            self?.removeFromSuperview()
        }
    }
}

// MARK: - BaseTapableViewDelegate
extension ToastView: BaseTapableViewDelegate {
    func didTapAction(inView view: BaseTapableView) {
        hide()
    }
}
