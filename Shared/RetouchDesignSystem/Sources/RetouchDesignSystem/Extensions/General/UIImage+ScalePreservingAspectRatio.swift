//
//  UIImage+ScalePreservingAspectRatio.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 14.06.2022.
//

import UIKit

public extension UIImage {
    @MainActor
    func scalePreservingAspectRatio(targetSize: CGSize = UIScreen.main.bounds.size) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
