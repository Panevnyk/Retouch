//
//  HomeViewModel.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 09.02.2021.
//

import UIKit
import Combine
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem
import Photos
import FactoryKit

enum HomeViewState {
    case gallery
    case history
    case noInternetConnection
    case noAccessToGallery
    case loading
}

@MainActor
public final class HomeViewModel: ObservableObject {
    // MARK: - Protocol
    @Injected(\.analytics) private var analytics
    
    // Boundaries
    private let dataLoader: DataLoaderProtocol
    private let ordersLoader: OrdersLoaderProtocol
    private let retouchGroupsLoader: RetouchGroupsLoaderProtocol
    private let phPhotoLibraryPresenter: PHPhotoLibraryPresenterProtocol
    private let reachabilityService: ReachabilityServiceProtocol
    private var freeGemCreditCountService: FreeGemCreditCountServiceProtocol

    // Data
    private var isInitialDataLoaded = false
    private var orders: [Order] = []
    private var retouchGroups: [RetouchGroup] = []
    private var isNetworkConnected: Bool
    private var isDataNeedToReload: Bool = true
    private var cancellable: [AnyCancellable] = []
    
    @Published var state: HomeViewState = .loading
    
    lazy var noInternetConnectionViewModel: PlaceholderViewModel = {
        PlaceholderViewModel(
            image: UIImage(named: "icNoInternetConnection", in: Bundle.designSystem, compatibleWith: nil),
            title: "Ooops!",
            subtitle: "It seems there is something wrong with your internet connection"
        )
    }()
    
    lazy var noAccessToGalleryViewModel: PlaceholderViewModel = {
        PlaceholderViewModel(
            image: UIImage(named: "icNoAccessToPhotoLibrary", in: Bundle.designSystem, compatibleWith: nil),
            title: "No access to photo library",
            subtitle: "To enable access please\ngo to your device setting",
            actionTitle: "Open Settings",
            action: openSettings
        )
    }()
    
    // MARK: - Inits
    public init(
        dataLoader: DataLoaderProtocol,
        ordersLoader: OrdersLoaderProtocol,
        retouchGroupsLoader: RetouchGroupsLoaderProtocol,
        phPhotoLibraryPresenter: PHPhotoLibraryPresenterProtocol,
        reachabilityService: ReachabilityServiceProtocol,
        freeGemCreditCountService: FreeGemCreditCountServiceProtocol
    ) {
        self.dataLoader = dataLoader
        self.ordersLoader = ordersLoader
        self.retouchGroupsLoader = retouchGroupsLoader
        self.phPhotoLibraryPresenter = phPhotoLibraryPresenter
        self.reachabilityService = reachabilityService
        self.freeGemCreditCountService = freeGemCreditCountService
        self.isNetworkConnected = reachabilityService.isNetworkConnected.value

        subscribeOnChanges()
    }
    
    private func loadData() {
        Task {
            await loadData()
        }
    }

    public func loadData() async {
        do {
            try await dataLoader.loadData()
        } catch {}
        self.isInitialDataLoaded = true
        self.reloadUIIfNeeded()
    }

    public func getOrdersCount() -> Int {
        return orders.count 
    }

    public func getRetouchGroups() -> [RetouchGroup] {
        return retouchGroups
    }

    public func requestPhotosAuthorization() async -> Bool {
        await phPhotoLibraryPresenter.requestPhotosAuthorization()
    }
    
    func needToShowFreeGemCreditCountAlert() -> Bool {
        return (UserData.shared.user.freeGemCreditCount ?? 0) > 0
        && ordersLoader.ordersPublisher.value.count == 0
        && freeGemCreditCountService.needToShowFreeGemsCountAlert
    }
    
    private func openSettings() {
        SettingsHelper.openSettings()
        analytics.logAction(.openSettings)
    }
}

// MARK: - bind
private extension HomeViewModel {
    func subscribeOnChanges() {
        ordersLoader.ordersPublisher
            .sink { orders in
                self.orders = orders
                self.reloadUIIfNeeded()
            }
            .store(in: &cancellable)

        retouchGroupsLoader.retouchGroupsPublisher
            .sink { retouchGroups in
                self.retouchGroups = retouchGroups
            }
            .store(in: &cancellable)

        reachabilityService.isNetworkConnected
            .sink { isNetworkConnected in
                self.isNetworkConnected = isNetworkConnected
                if isNetworkConnected {
                    if self.isDataNeedToReload {
                        self.isDataNeedToReload = false
                        self.loadData()
                    } else {
                        self.presentChildViewControllers()
                    }
                } else {
                    self.reloadUIIfNeeded()
                }
            }
            .store(in: &cancellable)
    }

    func reloadUIIfNeeded() {
        guard isInitialDataLoaded else { return }
        
        if needToShowFreeGemCreditCountAlert() {
            let diamondsCount = String(UserData.shared.user.freeGemCreditCount ?? 0)
            self.presentFirstRetouchingForFreeAlert(diamondsCount: diamondsCount) { [weak self] in
                guard let self = self else { return }
                self.freeGemCreditCountService.needToShowFreeGemsCountAlert = false
                self.presentChildViewControllers()
            }
        } else {
            presentChildViewControllers()
        }
    }
    
    func presentChildViewControllers() {
        Task {
            await presentChildViewControllers()
        }
    }
    
    func presentChildViewControllers() async {
        if !isNetworkConnected {
            state = .noInternetConnection
            analytics.logScreen(.internetConnectionErrorAlert)
        } else if orders.isEmpty {
            state = .loading
        
            let isAuthorized = await requestPhotosAuthorization()
            if isAuthorized {
                self.state = .gallery
            } else {
                self.state = .noAccessToGallery
                analytics.logScreen(.noAccessToGalleryAlert)
            }
        } else {
            state = .history
        }
    }
}

// MARK: - Alerts
private extension HomeViewModel {
    func presentFirstRetouchingForFreeAlert(diamondsCount: String, closeAction: (() -> Void)?) {
        analytics.logScreen(.firstRetouchingForFreeAlert)
        let gotIt = RTAlertAction(title: "Got it",
                                  style: .default,
                                  action: { closeAction?() })
        let img = UIImage(named: "icFirstOrderForFree", in: Bundle.designSystem, compatibleWith: nil)
        let alert = RTAlertController(title: "First retouching\nfor free",
                                      message: "Send your photo to our\ndesigners. You have \(diamondsCount) free\ndiamons for your first order.",
                                      image: img,
                                      actionPositionStyle: .horizontal)
        alert.addActions([gotIt])
        alert.show()
    }
}
