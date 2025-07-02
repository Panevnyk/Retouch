//
//  BaseCustomView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 11.11.2020.
//
import UIKit

/// Parent base view - that make your view save for creation in code, xib or as custom view in interfase builder
open class BaseCustomView: UIView {
    /// Inits
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    /// awakeFromNib
//    public override func awakeFromNib() {
//        super.awakeFromNib()
//        Task { @MainActor in
//            initialize()
//        }
//    }

    /// Base initialization method
    open func initialize() {}
}
