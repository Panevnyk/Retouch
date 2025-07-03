//
//  AssetsGalleryView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 19.09.2022.
//

import SwiftUI
import Photos
import RetouchUtils
import RetouchDesignSystem

public struct AssetsGalleryView: View {
    private static let spacing: CGFloat = 2

    private let assets: PHFetchResult<PHAsset>
    private var action: (_ asset: PHAsset) -> Void
    private var refreshable: @Sendable () async -> Void

    private let columns = [
        GridItem(spacing: AssetsGalleryView.spacing),
        GridItem(spacing: AssetsGalleryView.spacing),
        GridItem(spacing: AssetsGalleryView.spacing)
    ]
    
    private var targetSize: CGSize {
        let targetSide = UIScreen.main.bounds.width / 1.5
        return CGSize(width: targetSide, height: targetSide)
    }

    public init(
        assets: PHFetchResult<PHAsset>,
        action: @escaping (_ asset: PHAsset) -> Void,
        refreshable: @escaping @Sendable () async -> Void
    ) {
        self.assets = assets
        self.action = action
        self.refreshable = refreshable
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: AssetsGalleryView.spacing) {
                ForEach(0 ..< assets.count, id: \.self) { index in
                    AssetImage(
                        asset: assets[index],
                        index: index,
                        targetSize: targetSize,
                        completionHandler: nil,
                        onTapGesture: {
                            action(assets[index])
                        }
                    )
                    .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        .padding([.all], AssetsGalleryView.spacing)
        .refreshable(action: refreshable)
    }
}
