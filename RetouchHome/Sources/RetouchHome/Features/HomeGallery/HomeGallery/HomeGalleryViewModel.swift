//
//  HomeGalleryViewModel.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 19.09.2022.
//

import Combine
import Photos
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

@MainActor
public protocol HomeGalleryCoordinatorDelegate: BaseBalanceCoordinatorDelegate, BaseCoordinatorDelegate {
    func didSelectPhoto(asset: PHAsset)
    func didSelectCamera()
}

@MainActor
public class HomeGalleryViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    @Injected(\.analytics) private var analytics
    
    private var dataLoader: DataLoaderProtocol!
    private var phImageLoader: PHImageLoaderProtocol!

    @Published public var assets: PHFetchResult<PHAsset>
    @Published public var expandableTitle: String?
    @Published public var isBackHidden: Bool
    @Published public var expandableShowDetail = false

    private var isViewAppeared = false

    private weak var coordinatorDelegate: HomeGalleryCoordinatorDelegate?

    // MARK: - Inits
    public init(
        dataLoader: DataLoaderProtocol,
        phImageLoader: PHImageLoaderProtocol,
        assets: PHFetchResult<PHAsset>,
        expandableTitle: String? = nil,
        isBackHidden: Bool = true,
        coordinatorDelegate: HomeGalleryCoordinatorDelegate?
    ) {
        self.dataLoader = dataLoader
        self.phImageLoader = phImageLoader
        self.assets = assets
        self.expandableTitle = expandableTitle
        self.isBackHidden = isBackHidden
        self.coordinatorDelegate = coordinatorDelegate

        super.init()

        PHPhotoLibrary.shared().register(self)
    }

    // MARK: - Deinit
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    // MARK: - Public
    public func viewOnAppear() {
        guard !isViewAppeared else { return }
        isViewAppeared = true

        analytics.logScreen(.homeGallery)
    }
    
    public func refreshData() async {
        analytics.logAction(.refreshGallery)
        do {
            try await dataLoader.loadData()
        } catch {}
    }

    public func didSelectAlbum(assets: PHFetchResult<PHAsset>, title: String) {
        self.assets = assets
        expandableTitle = title
        expandableShowDetail = false
    }

    public func didSelectPhoto(asset: PHAsset) {
        coordinatorDelegate?.didSelectPhoto(asset: asset)
    }

    public func didSelectBalance() {
        coordinatorDelegate?.didSelectBalanceAction()
    }

    public func didSelectBack() {
        coordinatorDelegate?.didSelectBackAction()
    }

    public func didSelectCamera() {
        coordinatorDelegate?.didSelectCamera()
        analytics.logAction(.cameraFromGallery)
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension HomeGalleryViewModel: PHPhotoLibraryChangeObserver {
    nonisolated public func photoLibraryDidChange(_ changeInstance: PHChange) {
        Task { @MainActor in
            guard let change = changeInstance.changeDetails(for: assets) else { return }
            assets = change.fetchResultAfterChanges
        }
    }
}
