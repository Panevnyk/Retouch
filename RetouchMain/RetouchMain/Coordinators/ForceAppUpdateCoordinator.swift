//
//  ForceAppUpdateCoordinator.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 08.04.2021.
//

import UIKit
import RetouchHome

@MainActor
final class ForceAppUpdateCoordinator {
    // MARK: - Properties
    private let serviceFactory: ServiceFactoryProtocol
    private let navigationController: UINavigationController

    private weak var forceUpdateAppVersionViewController: ForceUpdateAppVersionViewController?

    // MARK: - Inits
    init(navigationController: UINavigationController,
         serviceFactory: ServiceFactoryProtocol) {
        self.navigationController = navigationController
        self.serviceFactory = serviceFactory
    }

    // MARK: - Starts
    func start(animated: Bool) {
        startForceAppUpdate(animated: animated)
    }

    private func startForceAppUpdate(animated: Bool) {
        let forceUpdateAppVersionViewController = ForceUpdateAppVersionViewController()
        self.forceUpdateAppVersionViewController = forceUpdateAppVersionViewController

        navigationController.setViewControllers([forceUpdateAppVersionViewController], animated: animated)
    }
}
