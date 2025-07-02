//
//  UIImageView+LoadByURL.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 23.01.2022.
//

import UIKit
import SwiftUI

@MainActor
public protocol RetouchImageLoader {
    func setImage(to imageView: UIImageView, from url: URL)
    func setImage(to imageView: UIImageView, from url: URL, activityIndicatorStyle: UIActivityIndicatorView.Style?)
    func makeImage<P: View>(for url: URL, @ViewBuilder _ content: @escaping () -> P) -> AnyView
}
