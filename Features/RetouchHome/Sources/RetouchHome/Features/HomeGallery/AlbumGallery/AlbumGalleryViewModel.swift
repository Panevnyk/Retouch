//
//  AlbumGalleryViewModel.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 11.10.2022.
//

import UIKit
import Photos
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

@MainActor
public class AlbumGalleryViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    @Injected(\.analytics) private var analytics
    
    private var sections: [AlbumCollectionSectionType] = [.all, .smartAlbums, .userCollections]
    @Published var allPhotos = PHFetchResult<PHAsset>()
    @Published var smartAlbums = PHFetchResult<PHAssetCollection>()
    @Published var userCollections = PHFetchResult<PHAssetCollection>()

    // MARK: - Inits
    public override init() {
        super.init()
    }

    // MARK: - Deinit
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    // MARK: - Public
    public func viewOnAppear() {
        getPermissionIfNecessary { granted in
            guard granted else { return }
            self.fetchAssets()
        }
        PHPhotoLibrary.shared().register(self)

        analytics.logScreen(.albumGallery)
    }
}

private extension AlbumGalleryViewModel {
    func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }

        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized ? true : false)
        }
    }

    func fetchAssets() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)

        let smartAlbumOptions = PHFetchOptions()
        smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .albumRegular,
            options: smartAlbumOptions)

        let albumOptions = PHFetchOptions()
        albumOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        userCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: albumOptions)
    }
}

// MARK: - Push
private extension AlbumGalleryViewModel {
    func push(toIndexPath indexPath: IndexPath) {
        let sectionType = sections[indexPath.section]
        let item = indexPath.item

        let assets: PHFetchResult<PHAsset>
        let title: String

        switch sectionType {
        case .all:
            assets = allPhotos
            title = AlbumCollectionSectionType.all.description
        case .smartAlbums, .userCollections:
            let album =
                sectionType == .smartAlbums ? smartAlbums[item] : userCollections[item]
            assets = PHAsset.fetchAssets(in: album, options: nil)
            title = album.localizedTitle ?? ""
        }

//        coordinatorDelegate?.didSelectAlbum(assets: assets, title: title)
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension AlbumGalleryViewModel: PHPhotoLibraryChangeObserver {
    nonisolated public func photoLibraryDidChange(_ changeInstance: PHChange) {
        Task { @MainActor in
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
            }
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
            }
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
            }
        }
    }
}

enum AlbumCollectionSectionType: Int, CustomStringConvertible {
    case all, smartAlbums, userCollections

    var description: String {
        switch self {
        case .all: return "All Photos"
        case .smartAlbums: return "Smart Albums"
        case .userCollections: return "User Collections"
        }
    }
}
