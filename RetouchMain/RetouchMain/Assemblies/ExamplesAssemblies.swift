//
//  ExamplesAssembly.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit
import RetouchExamples
import RetouchUtils
import RetouchDesignSystem

@MainActor
final class ExamplesAssembly {
    let viewModel: ExamplesViewModelProtocol
    var viewController: ExamplesViewController

    init(serviceFactory: ServiceFactoryProtocol) {
        let viewModel = ExamplesViewModel()
        let storyboard = UIStoryboard(name: "Examples", bundle: Bundle.examples)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ExamplesViewController") as! ExamplesViewController
        viewController.viewModel = viewModel

        self.viewModel = viewModel
        self.viewController = viewController
    }
}

@MainActor
final class ExampleDetailAssembly {
    var viewController: ExampleDetailViewController
    var viewModel: ExampleItemViewModelProtocol

    init(serviceFactory: ServiceFactoryProtocol,
         viewModel: ExampleItemViewModelProtocol) {
        let storyboard = UIStoryboard(name: "Examples", bundle: Bundle.examples)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ExampleDetailViewController") as! ExampleDetailViewController
        viewController.viewModel = viewModel

        self.viewController = viewController
        self.viewModel = viewModel
    }
}
