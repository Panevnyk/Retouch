//
//  MainTabBarCoordinator.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 09.02.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem
import CloudKit

@MainActor
protocol MainTabBarDelegate: AnyObject {
    func didSignout()
    func didSelectSignIn()
}

@MainActor
final class MainTabBarCoordinator {
    // MARK: - Properties
    private let serviceFactory: ServiceFactoryProtocol
    private let navigationController: UINavigationController
    private let tabBarController: UITabBarController

    weak var delegate: MainTabBarDelegate?

    private var homeNavigationController = UINavigationController()
    private var examplesNavigationController = UINavigationController()
    private var moreNavigationController = UINavigationController()

    private var homeCoordinator: HomeCoordinator?
    private var examplesCoordinator: ExamplesCoordinator?
    private var moreCoordinator: MoreCoordinator?

    // MARK: - Inits
    init(navigationController: UINavigationController, serviceFactory: ServiceFactoryProtocol) {
        self.navigationController = navigationController
        self.serviceFactory = serviceFactory
        self.tabBarController = UITabBarController()
        
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .kBackground

        homeNavigationController.navigationBar.isHidden = true
        examplesNavigationController.navigationBar.isHidden = true
        moreNavigationController.navigationBar.isHidden = true
    }

    func start(animated: Bool) {
        makeHomeTab()
        makeExamplesTab()
        makeMoreTab()

        homeCoordinator?.start(animated: false)
        examplesCoordinator?.start(animated: false)
        moreCoordinator?.start(animated: false)

        tabBarController.setViewControllers(
            [homeNavigationController,
             examplesNavigationController,
             moreNavigationController],
            animated: animated)
        tabBarController.selectedIndex = 0
        navigationController.setViewControllers([tabBarController], animated: animated)
    }
}


// MARK: - Make tabs
private extension MainTabBarCoordinator {
    func makeHomeTab() {
        let homeCoordinator = HomeCoordinator(
            navigationController: homeNavigationController,
            serviceFactory: serviceFactory)

        self.homeCoordinator = homeCoordinator
    }

    func makeExamplesTab() {
        let examplesCoordinator = ExamplesCoordinator(
            navigationController: examplesNavigationController,
            serviceFactory: serviceFactory)

        self.examplesCoordinator = examplesCoordinator
    }

    func makeMoreTab() {
        let moreCoordinator = MoreCoordinator(
            navigationController: moreNavigationController,
            serviceFactory: serviceFactory)
        moreCoordinator.delegate = self

        self.moreCoordinator = moreCoordinator
    }
}

// MARK: - MoreDelegate
extension MainTabBarCoordinator: MoreDelegate {
    func didSignout() {
        delegate?.didSignout()
    }
    
    func didSelectSignIn() {
        delegate?.didSelectSignIn()
    }
}
