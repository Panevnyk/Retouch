//
//  AlbumGalleryCollectionView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 11.10.2022.
//

import SwiftUI
import Photos
import RetouchUtils
import RetouchDesignSystem

struct AlbumGalleryCollectionView: View {
    var assetsCollections: PHFetchResult<PHAssetCollection>
    var coordinatorDelegate: AlbumGalleryCoordinatorDelegate?

    var body: some View {
        ForEach(0 ..< assetsCollections.count, id: \.self) { index in
            let collection = assetsCollections[index]
            let fetchedUserCollections = PHAsset.fetchAssets(in: collection, options: nil)
            AlbumGalleryItemView(assets: fetchedUserCollections,
                                 title: collection.localizedTitle,
                                 coordinatorDelegate: self)
        }
    }
}

// MARK: - AlbumGalleryCoordinatorDelegate
extension AlbumGalleryCollectionView: AlbumGalleryCoordinatorDelegate {
    func didSelectAlbum(assets: PHFetchResult<PHAsset>, title: String) {
        coordinatorDelegate?.didSelectAlbum(assets: assets, title: title)
    }
}
