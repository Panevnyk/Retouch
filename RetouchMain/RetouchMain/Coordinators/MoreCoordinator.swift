//
//  InfoCoordinator.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit
import RetouchMore
import RetouchUtils
import RetouchDesignSystem
import RetouchHome

@MainActor
protocol MoreDelegate: AnyObject {
    func didSignout()
    func didSelectSignIn()
}

@MainActor
final class MoreCoordinator {
    // MARK: - Properties
    private let serviceFactory: ServiceFactoryProtocol
    private let navigationController: UINavigationController

    private weak var moreViewController: MoreViewController?

    // Delegate
    weak var delegate: MoreDelegate?

    // MARK: - Inits
    init(navigationController: UINavigationController,
         serviceFactory: ServiceFactoryProtocol) {
        self.navigationController = navigationController
        self.serviceFactory = serviceFactory
    }

    // MARK: - Starts
    func start(animated: Bool) {
        startMore(animated: animated)
    }

    private func startMore(animated: Bool) {
        let moreAssembly = MoreAssembly(serviceFactory: serviceFactory)
        moreAssembly.viewController.setupTabBar()
        moreAssembly.viewController.coordinatorDelegate = self
        self.moreViewController = moreAssembly.viewController

        navigationController.setViewControllers([moreAssembly.viewController], animated: animated)
    }
}

// MARK: - BaseBalanceCoordinatorDelegate
extension MoreCoordinator: MoreCoordinatorDelegate {
    public func didSelectBalanceAction() {
        let balanceAssembly = BalanceAssembly(serviceFactory: serviceFactory)
        balanceAssembly.viewController.coordinatorDelegate = self

        navigationController.pushViewController(balanceAssembly.viewController, animated: true)
    }

    public func didSignout() {
        delegate?.didSignout()
    }

    func didSelectTermsAndConditions(from viewController: MoreViewController) {
        let infoAssembly = InfoAssembly(
            serviceFactory: serviceFactory,
            viewModel: viewController.viewModel.makeTermsAndConditionsViewModel()
        )
        infoAssembly.viewController.coordinatorDelegate = self

        navigationController.pushViewController(infoAssembly.viewController, animated: true)
    }

    func didSelectPrivacyPolicy(from viewController: MoreViewController) {
        let infoAssembly = InfoAssembly(
            serviceFactory: serviceFactory,
            viewModel: viewController.viewModel.makePrivacyPolicyViewModel()
        )
        infoAssembly.viewController.coordinatorDelegate = self

        navigationController.pushViewController(infoAssembly.viewController, animated: true)
    }
    
    func didSelectSignIn(from viewController: MoreViewController) {
        delegate?.didSelectSignIn()
    }
}

// MARK: - BalanceCoordinatorDelegate, InfoCoordinatorDelegate
extension MoreCoordinator: BalanceCoordinatorDelegate, InfoCoordinatorDelegate {
    public func didSelectBackAction() {
        navigationController.popViewController(animated: true)
    }
}
