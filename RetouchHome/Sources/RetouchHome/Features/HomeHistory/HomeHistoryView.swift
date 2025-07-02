//
//  HomeHistoryView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk  on 27.07.2023.
//

import SwiftUI
import Photos
import RetouchUtils
import RetouchDesignSystem

public struct HomeHistoryView: View {
    // MARK: - Properties
    @ObservedObject private var viewModel: HomeHistoryViewModel

    // MARK: - Inits
    public init(viewModel: HomeHistoryViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - UI
    public var body: some View {
        bodyView
            .onAppear(perform: viewModel.viewOnAppear)
    }

    var bodyView: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                HeaderSwiftView(
                    title: "Home",
                    balanceAction: viewModel.didSelectBalance
                )
                .padding(.bottom, 8)
             
                ScrollView {
                    if viewModel.isNotificationsAvailable {
                        NotificationBannerView(
                            viewModel: viewModel.getNotificationViewModel()
                        )
                        .padding(.all, 2)
                    }
                    
                    HomeHistoryGalleryView(
                        viewModels: viewModel.itemViewModels,
                        action: viewModel.didSelectItem
                    )
                }
                .refreshable {
                    await viewModel.refreshData()
                }
            }
            
            GalleryPhotoButton(
                galleryAction: viewModel.didSelectGallery,
                cameraAction: viewModel.didSelectCamera
            )
            .padding(.all, 16)
        }
        .background(Color.kBackground)
    }
}

// MARK: - Hosting
public class HomeHistoryViewHosting: HostingViewControllerWithoutNavBar<HomeHistoryView> {}
