//
//  HomeAssembly.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 09.02.2021.
//

import UIKit
import Photos
import RetouchDomain
import RetouchHome
import RetouchUtils
import RetouchDesignSystem
import SwiftUI

@MainActor
final class HomeAssembly {
    var viewController: HomeViewHosting

    init(
        serviceFactory: ServiceFactoryProtocol,
        bodySource: HomeViewBodySource
    ) {
        let viewModel = HomeViewModel(
            dataLoader: serviceFactory.makeDataLoader(),
            ordersLoader: serviceFactory.makeOrdersLoader(),
            retouchGroupsLoader: serviceFactory.makeRetouchGroupsLoader(),
            phPhotoLibraryPresenter: serviceFactory.makePHPhotoLibraryPresenter(),
            reachabilityService: serviceFactory.makeReachabilityService(),
            freeGemCreditCountService: serviceFactory.makeFreeGemCreditCountService()
        )
        let view = HomeView(
            viewModel: viewModel,
            bodySource: bodySource
        )
        let viewController = HomeViewHosting(
            rootView: view,
            hidesBottomBarWhenPushed: false
        )

        self.viewController = viewController
    }
}

@MainActor
final class HomeHistoryAssembly {
    var viewController: HomeHistoryViewHosting
    var view: HomeHistoryView

    init(
        serviceFactory: ServiceFactoryProtocol,
        coordinatorDelegate: HomeHistoryCoordinatorDelegate?
    ) {
        let viewModel = HomeHistoryViewModel(
            dataLoader: serviceFactory.makeDataLoader(),
            ordersLoader: serviceFactory.makeOrdersLoader(),
            retouchGroupsLoader: serviceFactory.makeRetouchGroupsLoader(),
            savePhotoInfoService: serviceFactory.makeSavePhotoInfoService(),
            coordinatorDelegate: coordinatorDelegate
        )
        let view = HomeHistoryView(viewModel: viewModel)
        let viewController = HomeHistoryViewHosting(rootView: view)
        
        self.viewController = viewController
        self.view = view
    }
}

@MainActor
final class HomeGalleryAssembly {
    var viewController: HomeGalleryViewHosting
    var view: HomeGalleryView

    init(
        serviceFactory: ServiceFactoryProtocol,
        coordinatorDelegate: HomeGalleryCoordinatorDelegate?,
        isBackHidden: Bool = true
    ) {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)

        let viewModel = HomeGalleryViewModel(
            dataLoader: serviceFactory.makeDataLoader(),
            phImageLoader: serviceFactory.makePHImageLoader(),
            assets: allPhotos,
            expandableTitle: "All photos",
            isBackHidden: isBackHidden,
            coordinatorDelegate: coordinatorDelegate
        )
        let view = HomeGalleryView(viewModel: viewModel)
        let viewController = HomeGalleryViewHosting(rootView: view)

        self.viewController = viewController
        self.view = view
    }
}

@MainActor
final class PhotoGalleryAssembly {
    var viewController: PhotoGalleryViewHosting
    var viewModel: PhotoGalleryViewModel

    convenience init(serviceFactory: ServiceFactoryProtocol,
                     retouchGroups: [RetouchGroup],
                     image: UIImage?) {
        let viewModel = PhotoGalleryViewModel(
            ordersLoader: serviceFactory.makeOrdersLoader(),
            phImageLoader: serviceFactory.makePHImageLoader(),
            retouchGroups: retouchGroups,
            iapService: serviceFactory.makeIAPService(),
            freeGemCreditCountService: serviceFactory.makeFreeGemCreditCountService(),
            image: image)
        self.init(serviceFactory: serviceFactory, photoViewModel: viewModel)
    }

    convenience init(serviceFactory: ServiceFactoryProtocol,
                     retouchGroups: [RetouchGroup],
                     asset: PHAsset) {
        let viewModel = AssetPhotoGalleryViewModel(
            ordersLoader: serviceFactory.makeOrdersLoader(),
            phImageLoader: serviceFactory.makePHImageLoader(),
            retouchGroups: retouchGroups,
            iapService: serviceFactory.makeIAPService(),
            freeGemCreditCountService: serviceFactory.makeFreeGemCreditCountService(),
            asset: asset)
        self.init(serviceFactory: serviceFactory, photoViewModel: viewModel)
    }

    private init(serviceFactory: ServiceFactoryProtocol,
                 photoViewModel: PhotoGalleryViewModel) {
        let view = PhotoGalleryView(viewModel: photoViewModel)
        let viewController = PhotoGalleryViewHosting(rootView: view)
        viewController.hidesBottomBarWhenPushed = true

        self.viewController = viewController
        self.viewModel = photoViewModel
    }
}

@MainActor
final class OrderDetailAssembly {
    var viewController: OrderDetailViewController
    var viewModel: OrderDetailViewModelProtocol

    init(
        serviceFactory: ServiceFactoryProtocol,
        order: Order
    ) {
        let viewModel = OrderDetailViewModel(
            ordersLoader: serviceFactory.makeOrdersLoader(),
            retouchGroupsLoader: serviceFactory.makeRetouchGroupsLoader(),
            feedbackService: serviceFactory.makeFeedbackService(),
            order: order
        )
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.home)
        let viewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
        viewController.viewModel = viewModel

        self.viewController = viewController
        self.viewModel = viewModel
    }
}

@MainActor
final class RetouchingPhotoAssembly {
    var viewController: RetouchingPhotoViewController
    var viewModel: RetouchingPhotoViewModelProtocol

    init(serviceFactory: ServiceFactoryProtocol, order: Order) {
        let viewModel = RetouchingPhotoViewModel(order: order)
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.home)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RetouchingPhotoViewController") as! RetouchingPhotoViewController
        viewController.viewModel = viewModel
        viewModel.delegate = viewController

        self.viewController = viewController
        self.viewModel = viewModel
    }
}

@MainActor
final class BalanceAssembly {
    var viewController: BalanceViewController
    var viewModel: BalanceViewModelProtocol

    init(serviceFactory: ServiceFactoryProtocol, orderAmount: Int? = nil) {
        let viewModel = BalanceViewModel(
            iapService: serviceFactory.makeIAPService(),
            earnCreditsService: serviceFactory.makeEarnCreditsService(),
            orderAmount: orderAmount
        )
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.home)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BalanceViewController") as! BalanceViewController
        viewController.viewModel = viewModel
        viewModel.delegate = viewController

        self.viewController = viewController
        self.viewModel = viewModel
    }
}

@MainActor
final class CancelMessageAssembly {
    var viewController: MessageViewController

    init(order: Order) {
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.home)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        viewController.imageString = "icPhotoRetouchingReady"
        viewController.screenTitle = "Photo is canceled\nby designer"
        let cancelText = order.statusDescription ?? ""
        viewController.message = "\"\(cancelText)\""

        self.viewController = viewController
    }
}
