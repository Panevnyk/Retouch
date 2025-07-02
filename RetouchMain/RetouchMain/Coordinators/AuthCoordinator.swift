//
//  AuthCoordinator.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 12.03.2021.
//

import UIKit
import RetouchAuth
import RetouchMore
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

@MainActor
protocol AuthCoordinatorDelegate: AnyObject {
    func didLoginSuccessfully()
}

@MainActor
final class AuthCoordinator {
    // MARK: - Properties
    @Injected(\.analytics) private var analytics
    
    private let serviceFactory: ServiceFactoryProtocol
    private let navigationController: UINavigationController

    // Delegate
    weak var delegate: AuthCoordinatorDelegate?

    // MARK: - Inits
    init(navigationController: UINavigationController,
         serviceFactory: ServiceFactoryProtocol) {
        self.navigationController = navigationController
        self.serviceFactory = serviceFactory
    }

    // MARK: - Starts
    func start(animated: Bool) {
        if StartingTutorialView.isShowen {
            startAuth(animated: animated)
        } else {
            startTutorialAuth(animated: animated)
        }
    }

    func startResetPasswordScreen(resetPasswordToken: String, animated: Bool) {
        let loginViewController = makeLoginViewController()
        let forgotPasswordViewController = makeForgotPasswordViewController()
        let resetPasswordViewController = makeResetPasswordViewController(resetPasswordToken: resetPasswordToken)
        navigationController.setViewControllers(
            [loginViewController, forgotPasswordViewController, resetPasswordViewController],
            animated: animated)
    }

    func startAuth(animated: Bool) {
        let fastSigninViewController = makeFastSigninViewController()
        navigationController.setViewControllers([fastSigninViewController], animated: animated)
    }

    func startTutorialAuth(animated: Bool) {
        let startingTutorialViewController = makeStartingTutorialViewController()
        navigationController.setViewControllers([startingTutorialViewController], animated: animated)
    }
}

// MARK: - ViewController Factories
private extension AuthCoordinator {
    func makeStartingTutorialViewController() -> UIViewController {
        let startingTutorialAssembly = StartingTutorialAssembly(
            serviceFactory: serviceFactory,
            coordinatorDelegate: self
        )
        return startingTutorialAssembly.viewController
    }
    
    func makeFastSigninViewController() -> UIViewController {
        let fastSigninAssembly = FastSigninAssembly(
            serviceFactory: serviceFactory,
            coordinatorDelegate: self
        )
        return fastSigninAssembly.viewController
    }

    func makeLoginViewController(defaultEmail: String? = nil) -> UIViewController {
        let loginAssembly = LoginAssembly(
            serviceFactory: serviceFactory,
            defaultEmail: defaultEmail,
            coordinatorDelegate: self
        )
        return loginAssembly.viewController
    }

    func makeRegistrationViewController() -> UIViewController {
        let registrationAssembly = RegistrationAssembly(
            serviceFactory: serviceFactory,
            coordinatorDelegate: self
        )
        return registrationAssembly.viewController
    }
    
    func makeForgotPasswordViewController() -> UIViewController {
        let forgotPasswordAssembly = ForgotPasswordAssembly(
            serviceFactory: serviceFactory,
            coordinatorDelegate: self
        )
        return forgotPasswordAssembly.viewController
    }

    func makeResetPasswordViewController(resetPasswordToken: String) -> UIViewController {
        let resetPasswordAssembly = ResetPasswordAssembly(
            resetPasswordToken: resetPasswordToken,
            serviceFactory: serviceFactory,
            coordinatorDelegate: self
        )
        return resetPasswordAssembly.viewController
    }

    func makePrivacyPolicyViewController() -> InfoViewController {
        let infoAssembly = InfoAssembly(serviceFactory: serviceFactory, viewModel: PrivacyPolicyViewModel())
        infoAssembly.viewController.coordinatorDelegate = self
        return infoAssembly.viewController
    }
    
    func makeTermsOfUseViewController() -> InfoViewController {
        let infoAssembly = InfoAssembly(serviceFactory: serviceFactory, viewModel: TermsAndConditionsViewModel())
        infoAssembly.viewController.coordinatorDelegate = self
        return infoAssembly.viewController
    }
}

// MARK: - AStartingTutorialViewCoordinatorDelegate
extension AuthCoordinator: StartingTutorialViewCoordinatorDelegate {
    public func didSelectUseApp() {
        didLoginSuccessfully()
    }
}

// MARK: - AFastSignInViewCoordinatorDelegate
extension AuthCoordinator: AFastSignInViewCoordinatorDelegate {
    public func didSelectUseOtherSigninOptions() {
        didSelectLogin()
    }
}

// MARK: - BaseLoginCoordinatorDelegate
extension AuthCoordinator: BaseLoginCoordinatorDelegate {
    public func didLoginSuccessfully() {
        delegate?.didLoginSuccessfully()
    }
}

// MARK: - BaseAuthCoordinatorDelegate
extension AuthCoordinator: BaseAuthCoordinatorDelegate {
    func didSelectLogin() {
        didSelectLogin(animated: true)
    }

    func didSelectLogin(animated: Bool) {
        let loginViewController = makeLoginViewController()
        navigationController.setViewControllers([loginViewController], animated: animated)
    }

    func didSelectSignUp() {
        let registrationViewController = makeRegistrationViewController()
        navigationController.setViewControllers([registrationViewController], animated: true)
    }
}

// MARK: - LoginViewCoordinatorDelegate
extension AuthCoordinator: LoginViewCoordinatorDelegate {
    func didSelectForgotPassword() {
        let forgotPasswordViewController = makeForgotPasswordViewController()
        navigationController.pushViewController(forgotPasswordViewController, animated: true)
    }
}

// MARK: - RegistrationViewCoordinatorDelegate
extension AuthCoordinator: RegistrationViewCoordinatorDelegate {
    func successRegistration() {
        didLoginSuccessfully()
    }
}

// MARK: - ForgotPasswordViewCoordinatorDelegate
extension AuthCoordinator: ForgotPasswordViewCoordinatorDelegate {
    func didSelectLoginWith(email: String) {
        let loginViewController = makeLoginViewController(defaultEmail: email)
        navigationController.setViewControllers([loginViewController], animated: true)
    }

    func dissmiss() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - ResetPasswordViewCoordinatorDelegate
extension AuthCoordinator: ResetPasswordViewCoordinatorDelegate {}

// MARK: - UseAgreementsDelegate
extension AuthCoordinator: UseAgreementsDelegate {
    func didSelectPrivacyPolicy() {
        analytics.logAction(.privacyPolicyAuth)
        let infoViewController = makePrivacyPolicyViewController()
        navigationController.pushViewController(infoViewController, animated: true)
    }
    
    func didSelectTermsOfUse() {
        analytics.logAction(.termsOfUseAuth)
        let infoViewController = makeTermsOfUseViewController()
        navigationController.pushViewController(infoViewController, animated: true)
    }
}

// MARK: - InfoCoordinatorDelegate
extension AuthCoordinator: InfoCoordinatorDelegate {
    public func didSelectBackAction() {
        navigationController.popViewController(animated: true)
    }
}
