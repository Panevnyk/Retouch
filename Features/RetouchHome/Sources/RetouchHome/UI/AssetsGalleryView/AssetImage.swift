//
//  AssetImage.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 19.09.2022.
//

import SwiftUI
import Photos

public struct AssetImage: View {
    @ObservedObject private var viewModel: AssetImageViewModel
    private var tapGesture: (() -> Void)?

    public init(asset: PHAsset?,
                index: Int,
                targetSize: CGSize,
                completionHandler: ((Bool) -> Void)?,
                onTapGesture tapGesture: (() -> Void)?) {
        self.viewModel = AssetImageViewModel()
        self.tapGesture = tapGesture
        viewModel.fetchImageAsset(asset,
                                  index: index,
                                  targetSize: targetSize,
                                  completionHandler: completionHandler)
    }

    public var body: some View {
        makeImage()
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
            .aspectRatio(1, contentMode: .fit)
            .contentShape(Rectangle())
            .onTapGesture {
                self.tapGesture?()
            }
    }

    private func makeImage() -> Image {
        if let image = viewModel.image {
            return Image(uiImage: image)
        } else {
            return Image("icImagePlaceholder", bundle: .designSystem)
        }
    }
}

final class AssetImageViewModel: ObservableObject {
    @Published var image: UIImage?

    private var currentIndex: Int?

    func fetchImageAsset(_ asset: PHAsset?,
                         index: Int? = nil,
                         targetSize size: CGSize,
                         contentMode: PHImageContentMode = .aspectFill,
                         options: PHImageRequestOptions? = nil,
                         completionHandler: ((Bool) -> Void)?) {

        guard let asset = asset else { completionHandler?(false); return }

        let resultHandler: (UIImage?, [AnyHashable: Any]?) -> Void = { [weak self] image, info in
            var isNeedToUpdate = true
            if let index = index,
               let currentIndex = self?.currentIndex,
               index != currentIndex {
                isNeedToUpdate = false
            }

            if isNeedToUpdate {
                self?.image = image
            }
            completionHandler?(isNeedToUpdate)
        }

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: size,
            contentMode: contentMode,
            options: options,
            resultHandler: resultHandler)
    }
}
