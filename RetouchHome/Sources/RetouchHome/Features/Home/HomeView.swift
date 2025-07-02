//
//  HomeView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk  on 25.08.2023.
//

import SwiftUI
import Combine
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem

@MainActor
public protocol HomeViewBodySource: AnyObject {
    func homeHistoryView() -> HomeHistoryView
    func homeGalleryView() -> HomeGalleryView
}

public struct HomeView: View {
    // MARK: - Properties
    @ObservedObject fileprivate var viewModel: HomeViewModel
    private var bodySource: HomeViewBodySource

    // MARK: - Inits
    public init(
        viewModel: HomeViewModel,
        bodySource: HomeViewBodySource
    ) {
        _viewModel = .init(wrappedValue: viewModel)
        self.bodySource = bodySource
    }

    // MARK: - UI
    public var body: some View {
        bodyView
            .background(Color.kBackground)
    }
    
    private var bodyView: some View {
        ZStack {
            switch viewModel.state {
            case .gallery:
                bodySource.homeGalleryView()
                
            case .history:
                bodySource.homeHistoryView()
                
            case .noInternetConnection:
                PlaceholderView(viewModel: viewModel.noInternetConnectionViewModel)
                
            case .noAccessToGallery:
                PlaceholderView(viewModel: viewModel.noAccessToGalleryViewModel)
                
            case .loading:
                ProgressView()
            }
        }
    }
}

// MARK: - Hosting
public class HomeViewHosting: HostingViewControllerWithoutNavBar<HomeView> {
    public func setupTabBar() {
        tabBarItem.image = MainTab.home.image
        tabBarItem.selectedImage = MainTab.home.selectedImage
        tabBarItem.title = "Home"
    }
    
    public func getRetouchGroups() -> [RetouchGroup] {
        return rootSwiftUIView.viewModel.getRetouchGroups()
    }
}
