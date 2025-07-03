//
//  ScrollableImage.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 18.10.2022.
//

import UIKit
import SwiftUI

public struct ScrollableImage: View {
    private var image: UIImage?

    public init(image: UIImage?) {
        self.image = image
    }

    public var body: some View {
        if let image = image {
            GeometryReader { proxy in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
            }
        } else {
            ProgressView()
        }
    }
}

struct ScrollableImage_Previews: PreviewProvider {
    static var previews: some View {
        ScrollableImage(image: nil)
    }
}
