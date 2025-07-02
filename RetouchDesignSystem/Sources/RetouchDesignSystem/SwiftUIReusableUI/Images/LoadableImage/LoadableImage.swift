//
//  LoadableImage.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk  on 28.07.2023.
//

import SwiftUI
import UIKit
import RetouchUtils

public struct LoadableImage: View {
    private let loader: RetouchImageLoader
    private let imageUrl: String?
    private let placeholder: (name: String, bundle: Bundle)?
    private let contentMode: SwiftUI.ContentMode
    private let targetSize: CGSize?
    private var action: (() -> Void)?
    
    private var url: URL? {
        if let imageUrl = imageUrl {
            return URL(string: imageUrl)
        }
        
        return nil
    }
    
    public init(
        loader: RetouchImageLoader,
        imageUrl: String?,
        placeholder: (name: String, bundle: Bundle)? = nil,
        contentMode: SwiftUI.ContentMode = .fill,
        targetSize: CGSize? = nil,
        action: (() -> Void)? = nil
    ) {
        self.loader = loader
        self.imageUrl = imageUrl
        self.placeholder = placeholder
        self.contentMode = contentMode
        self.targetSize = targetSize
        self.action = action
    }
    
    public var body: some View {
        if let action = action {
            Button(action: action) {
                asyncTargetedSizeImage
            }
        } else {
            asyncTargetedSizeImage
        }
    }
    
    private var asyncTargetedSizeImage: some View {
        ZStack {
            if let targetSize = targetSize {
                asyncImage
                    .frame(width: targetSize.width, height: targetSize.height)
            } else {
                asyncImage
            }
        }
    }
     
    private var asyncImage: some View {
        ZStack {
            if let url {
                loader
                    .makeImage(for: url) {
                        placeholderImage
                    }
                    .aspectRatio(contentMode: contentMode)
            }
        }
    }
    
    private var placeholderImage: some View {
        ZStack {
            if let placeholder = placeholder {
                Image(placeholder.name, bundle: placeholder.bundle)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                ProgressView()
            }
        }
    }
}

struct LoadableImage_Previews: PreviewProvider {
    static var previews: some View {
        LoadableImage(
            loader: MockImageLoader(),
            imageUrl: "Mock",
            placeholder: (name: "Placeholder", bundle: .module),
            action: nil
        )
    }
}

@MainActor
final class MockImageLoader: RetouchImageLoader {
    func setImage(to imageView: UIImageView, from url: URL) {}
    func setImage(to imageView: UIImageView, from url: URL, activityIndicatorStyle: UIActivityIndicatorView.Style?) {}
    func makeImage<P: View>(for url: URL, @ViewBuilder _ content: @escaping () -> P) -> AnyView {
        return AnyView(EmptyView())
    }
}
