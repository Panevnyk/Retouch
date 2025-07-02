// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit
import SwiftUI
import Kingfisher
import RetouchUtils

@MainActor
public class RetouchImageLoaderImp: RetouchImageLoader {
    nonisolated public init() {}
    
    public func setImage(to imageView: UIImageView, from url: URL) {
        setImage(to: imageView, from: url, activityIndicatorStyle: .medium)
    }
    
    public func setImage(to imageView: UIImageView, from url: URL, activityIndicatorStyle: UIActivityIndicatorView.Style? = .medium) {
        if let activityIndicatorStyle = activityIndicatorStyle {
            let activityInd = UIActivityIndicatorView(style: activityIndicatorStyle)
            activityInd.center = CGPoint(x: imageView.frame.size.width / 2,
                                         y: imageView.frame.size.height / 2)
            imageView.addSubview(activityInd)
            activityInd.startAnimating()
            imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { _ in
                activityInd.stopAnimating()
            }
        } else {
            imageView.kf.setImage(with: url)
        }
    }

    public func makeImage<P: View>(for url: URL, @ViewBuilder _ content: @escaping () -> P) -> AnyView {
        AnyView(
            KFImage(url)
                .placeholder(content)
                .resizable()
        )
    }
}
