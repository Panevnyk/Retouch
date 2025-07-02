//
//  ActivityIndicatorView.swift
//  Retouch
//
//  Created by Panevnyk Vlad on 3/23/20.
//

import UIKit

@objc(ActivityIndicatorView)
final class ActivityIndicatorView: UIView, DetailAnimable {

    @IBOutlet private var xibView: UIView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var activityIndecator: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        addSelfNibUsingConstraints(bundle: Bundle.module)
        initialize()
    }
    
    func initialize() {
        alpha = 0
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.kSeparatorGray.cgColor
        contentView.layer.cornerRadius = 6
        contentView.backgroundColor = UIColor.kInputBackgroundGrey
    }
    
    func show() {
        showView()
        activityIndecator.startAnimating()
    }
    
    func hide() {
        hideView { [weak self] in
            self?.activityIndecator.stopAnimating()
            self?.removeFromSuperview()
        }
    }
    
}
