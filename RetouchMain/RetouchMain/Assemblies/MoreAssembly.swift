//
//  InfoAssembly.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit
import RetouchMore
import RetouchUtils
import RetouchDesignSystem

@MainActor
final class MoreAssembly {
    let viewModel: MoreViewModelProtocol
    var viewController: MoreViewController

    init(serviceFactory: ServiceFactoryProtocol) {
        let viewModel = MoreViewModel(restApiManager: serviceFactory.makeRestApiManager(),
                                      dataLoader: serviceFactory.makeDataLoader())
        let storyboard = UIStoryboard(name: "More", bundle: Bundle.more)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        viewController.viewModel = viewModel

        self.viewModel = viewModel
        self.viewController = viewController
    }
}

@MainActor
final class InfoAssembly {
    let viewModel: InfoViewModelProtocol
    var viewController: InfoViewController

    init(serviceFactory: ServiceFactoryProtocol,
         viewModel: InfoViewModelProtocol) {
        let storyboard = UIStoryboard(name: "More", bundle: Bundle.more)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        viewController.viewModel = viewModel

        self.viewModel = viewModel
        self.viewController = viewController
    }
}
