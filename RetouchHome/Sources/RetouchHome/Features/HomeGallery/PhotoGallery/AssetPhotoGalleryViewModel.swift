//
//  AssetPhotoGalleryViewModel.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 18.10.2022.
//

import UIKit
import Photos
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem

@MainActor
public class AssetPhotoGalleryViewModel: PhotoGalleryViewModel {
    public init(ordersLoader: OrdersLoaderProtocol,
                phImageLoader: PHImageLoaderProtocol,
                retouchGroups: [RetouchGroup],
                iapService: IAPServiceProtocol,
                freeGemCreditCountService: FreeGemCreditCountServiceProtocol,
                asset: PHAsset) {
        super.init(ordersLoader: ordersLoader,
                   phImageLoader: phImageLoader,
                   retouchGroups: retouchGroups,
                   iapService: iapService,
                   freeGemCreditCountService: freeGemCreditCountService,
                   image: nil)

        Task {
            await loadImage(asset: asset)
        }
    }

    private func loadImage(asset: PHAsset) async {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true

        ActivityIndicatorHelper.shared.show()
        let image = await phImageLoader.fetchImage(
            asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFill,
            options: options
        )
        ActivityIndicatorHelper.shared.hide()
        self.image = image
        
    }
}
