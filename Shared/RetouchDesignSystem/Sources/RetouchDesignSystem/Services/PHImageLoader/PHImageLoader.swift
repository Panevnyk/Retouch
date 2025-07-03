//
//  PHImageLoader.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 16.02.2021.
//

import UIKit
import Photos

public protocol PHImageLoaderProtocol: Sendable {
    func fetchImage(
        _ asset: PHAsset?,
        targetSize size: CGSize,
        contentMode: PHImageContentMode,
        options: PHImageRequestOptions?
    ) async -> UIImage?
}

public final class PHImageLoader: PHImageLoaderProtocol, Sendable {
    public init() {}

    public func fetchImage(
        _ asset: PHAsset?,
        targetSize size: CGSize,
        contentMode: PHImageContentMode = .aspectFill,
        options: PHImageRequestOptions? = nil
    ) async -> UIImage? {
        guard let asset = asset else {
            return nil
        }

        return await withCheckedContinuation { continuation in
            let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { image, info in
                continuation.resume(returning: image)
            }
            
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: size,
                contentMode: contentMode,
                options: options,
                resultHandler: resultHandler)
        }
    }
}
