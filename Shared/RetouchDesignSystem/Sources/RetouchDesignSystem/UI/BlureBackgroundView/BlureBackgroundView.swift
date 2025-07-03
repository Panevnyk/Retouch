//
//  BlureBackgroundView.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 26.11.2021.
//

import UIKit
import SwiftUI

public struct BlureBackgroundViewRepresentable: UIViewRepresentable {
    private let title: String
    private let image: String
    
    public init(
        title: String,
        image: String
    ) {
        self.title = title
        self.image = image
    }
    
    public func makeUIView(context: Context) -> BlureBackgroundView {
        let view = BlureBackgroundView()
        return view
    }
    
    public func updateUIView(_ uiView: BlureBackgroundView, context: Context) {
        uiView.setTitle(title)
        let image = UIImage(named: image,
                            in: Bundle.module,
                            compatibleWith: nil)
        uiView.setImage(image)
    }
}

@objc(BlureBackgroundView)
public class BlureBackgroundView: BaseCustomView, DetailAnimable {
    @IBOutlet private var visualEfectView: UIVisualEffectView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    
    public override func initialize() {
        addSelfNibUsingConstraints(bundle: Bundle.module)
        
        alpha = 0
        visualEfectView.alpha = 0.9
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont.kBigTitleText
    }
    
    public func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    public func setImage(_ image: UIImage?) {
        imageView.image = image
    }
}
