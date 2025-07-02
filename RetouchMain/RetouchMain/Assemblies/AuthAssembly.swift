//
//  AuthAssembly.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 12.03.2021.
//

import UIKit
import RetouchAuth
import SwiftUI

@MainActor
final class StartingTutorialAssembly {
    let viewController: UIViewController

    init(
        serviceFactory: ServiceFactoryProtocol,
        coordinatorDelegate: StartingTutorialViewCoordinatorDelegate?
    ) {
        let viewModel = StartingTutorialViewModel(
            coordinatorDelegate: coordinatorDelegate
        )
        let view = StartingTutorialView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)

        self.viewController = viewController
    }
}

@MainActor
final class FastSigninAssembly {
    let viewController: UIViewController

    init(
        serviceFactory: ServiceFactoryProtocol,
        coordinatorDelegate: AFastSignInViewCoordinatorDelegate?
    ) {
        let viewModel = FastSignInViewModel(
            restApiManager: serviceFactory.makeRestApiManager(),
            coordinatorDelegate: coordinatorDelegate
        )
        let view = FastSignInView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)

        self.viewController = viewController
    }
}

@MainActor
final class LoginAssembly {
    let viewController: UIViewController

    init(
        serviceFactory: ServiceFactoryProtocol,
        defaultEmail: String?,
        coordinatorDelegate: LoginViewCoordinatorDelegate?
    ) {
        let viewModel = LoginViewModel(
            restApiManager: serviceFactory.makeRestApiManager(),
            defaultEmail: defaultEmail,
            coordinatorDelegate: coordinatorDelegate
        )
        let view = LoginView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)

        self.viewController = viewController
    }
}

@MainActor
final class RegistrationAssembly {
    let viewController: UIViewController

    init(
        serviceFactory: ServiceFactoryProtocol,
        coordinatorDelegate: RegistrationViewCoordinatorDelegate?
    ) {
        let viewModel = RegisterationViewModel(
            restApiManager: serviceFactory.makeRestApiManager(),
            coordinatorDelegate: coordinatorDelegate
        )
        let view = RegisterationView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)

        self.viewController = viewController
    }
}

@MainActor
final class ForgotPasswordAssembly {
    let viewController: UIViewController

    init(
        serviceFactory: ServiceFactoryProtocol,
        coordinatorDelegate: ForgotPasswordViewCoordinatorDelegate?
    ) {
        let viewModel = ForgotPasswordViewModel(
            restApiManager: serviceFactory.makeRestApiManager(),
            coordinatorDelegate: coordinatorDelegate
        )
        let view = ForgotPasswordView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)

        self.viewController = viewController
    }
}

@MainActor
final class ResetPasswordAssembly {
    let viewController: UIViewController
    
    init(
        resetPasswordToken: String,
        serviceFactory: ServiceFactoryProtocol,
        coordinatorDelegate: ResetPasswordViewCoordinatorDelegate?
    ) {
        let viewModel = ResetPasswordViewModel(
            resetPasswordToken: resetPasswordToken,
            restApiManager: serviceFactory.makeRestApiManager(),
            coordinatorDelegate: coordinatorDelegate
        )
        let view = ResetPasswordView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        
        self.viewController = viewController
    }
}
