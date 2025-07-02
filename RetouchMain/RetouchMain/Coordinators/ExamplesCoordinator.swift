//
//  ExamplesCoordinator.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit
import RetouchExamples
import RetouchUtils
import RetouchDesignSystem
import RetouchHome

@MainActor
final class ExamplesCoordinator {
    // MARK: - Properties
    private let serviceFactory: ServiceFactoryProtocol
    private let navigationController: UINavigationController

    private weak var examplesViewController: ExamplesViewController?
    private weak var exampleDetailViewController: ExampleDetailViewController?

    // MARK: - Inits
    init(navigationController: UINavigationController,
         serviceFactory: ServiceFactoryProtocol) {
        self.navigationController = navigationController
        self.serviceFactory = serviceFactory
    }

    // MARK: - Starts
    func start(animated: Bool) {
        startExamples(animated: animated)
    }

    private func startExamples(animated: Bool) {
        let examplesAssembly = ExamplesAssembly(serviceFactory: serviceFactory)
        examplesAssembly.viewController.setupTabBar()
        examplesAssembly.viewController.coordinatorDelegate = self
        self.examplesViewController = examplesAssembly.viewController

        navigationController.setViewControllers([examplesAssembly.viewController], animated: animated)
    }
}

// MARK: - ExamplesCoordinatorDelegate
extension ExamplesCoordinator: ExamplesCoordinatorDelegate {
    public func didSelectExampleItem(_ viewModel: ExampleItemViewModelProtocol,
                              from viewController: ExamplesViewController) {
        let exampleDetailAssembly = ExampleDetailAssembly(serviceFactory: serviceFactory, viewModel: viewModel)
        self.exampleDetailViewController = exampleDetailAssembly.viewController

        navigationController.pushViewController(exampleDetailAssembly.viewController, animated: true)
    }

    public func didSelectBalanceAction() {
        let balanceAssembly = BalanceAssembly(serviceFactory: serviceFactory)
        balanceAssembly.viewController.coordinatorDelegate = self

        navigationController.pushViewController(balanceAssembly.viewController, animated: true)
    }
}

// MARK: - BalanceCoordinatorDelegate
extension ExamplesCoordinator: BalanceCoordinatorDelegate {
    public func didSelectBackAction() {
        navigationController.popViewController(animated: true)
    }
}
