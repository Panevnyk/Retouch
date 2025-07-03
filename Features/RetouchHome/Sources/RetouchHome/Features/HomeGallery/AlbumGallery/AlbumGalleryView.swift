//
//  AlbumGalleryView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 11.10.2022.
//

import SwiftUI
import Photos
import RetouchUtils
import RetouchDesignSystem

public struct AlbumGalleryView: View {
    // MARK: - Properties
    @ObservedObject private var viewModel: AlbumGalleryViewModel
    private var coordinatorDelegate: AlbumGalleryCoordinatorDelegate?

    // MARK: - Inits
    public init(viewModel: AlbumGalleryViewModel,
                coordinatorDelegate: AlbumGalleryCoordinatorDelegate?) {
        self.viewModel = viewModel
        self.coordinatorDelegate = coordinatorDelegate
    }

    // MARK: - UI
    public var body: some View {
        bodyView
            .onAppear(perform: viewModel.viewOnAppear)
    }

    var bodyView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                AlbumGalleryItemView(assets: viewModel.allPhotos,
                                     title: "All photos",
                                     coordinatorDelegate: coordinatorDelegate)

                AlbumGalleryCollectionView(assetsCollections: viewModel.smartAlbums,
                                           coordinatorDelegate: coordinatorDelegate)

                AlbumGalleryCollectionView(assetsCollections: viewModel.userCollections,
                                           coordinatorDelegate: coordinatorDelegate)
            }
            .padding(.all, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
