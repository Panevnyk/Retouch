//
//  AppCoordinator.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 09.02.2021.
//

import UIKit
import SwiftUI
import RetouchDomain
import RetouchAuth
import RetouchMore
import RetouchUtils
import RetouchDesignSystem

@MainActor
final class AppCoordinator {
    // MARK: - Properties
    private let window: UIWindow
    private let serviceFactory: ServiceFactoryProtocol
    private let navigationController: UINavigationController

    // Coordinators
    private var forceAppUpdateCoordinator: ForceAppUpdateCoordinator?
    private var mainTabBarCoordinator: MainTabBarCoordinator?
    private var authCoordinator: AuthCoordinator?

    // MARK: - Inits
    init?(window: UIWindow?, serviceFactory: ServiceFactoryProtocol) {
        guard let window = window else { return nil }
        self.window = window
        self.serviceFactory = serviceFactory
        self.navigationController = UINavigationController()

        setupAppearance()
        navigationController.navigationBar.isHidden = true
        navigationController.isNavigationBarHidden = true
        subscribe()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func setupAppearance() {
        UITabBar.appearance().tintColor = UIColor.kPurple
        UITabBar.appearance().unselectedItemTintColor = UIColor.kGrayText
    }

    func start() {
        if StartingTutorialView.isShowen {
            startMainTabBarCoordinator(animated: false)
        } else {
            startTutorialAuthCoordinator(animated: false)
        }
    }

    func start(deepLinkType: DeepLinkType) {
        switch deepLinkType {
        case .resetPassword(let resetPasswordToken):
            startAuthResetPasswordScreenCoordinator(resetPasswordToken: resetPasswordToken, animated: false)
        }
    }

    func startForceAppUpdating(animated: Bool) {
        let forceAppUpdateCoordinator = ForceAppUpdateCoordinator(
            navigationController: navigationController,
            serviceFactory: serviceFactory)
        forceAppUpdateCoordinator.start(animated: animated)

        self.forceAppUpdateCoordinator = forceAppUpdateCoordinator
        self.mainTabBarCoordinator = nil
        self.authCoordinator = nil
    }
    
    func startMainTabBarCoordinator(animated: Bool) {
        logInSettings()

        let mainTabBarCoordinator = MainTabBarCoordinator(
            navigationController: navigationController,
            serviceFactory: serviceFactory)
        mainTabBarCoordinator.delegate = self
        mainTabBarCoordinator.start(animated: animated)

        self.mainTabBarCoordinator = mainTabBarCoordinator
        self.authCoordinator = nil
        self.forceAppUpdateCoordinator = nil
    }

    func startTutorialAuthCoordinator(animated: Bool) {
        logOutSettings()

        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            serviceFactory: serviceFactory)
        authCoordinator.delegate = self
        authCoordinator.startTutorialAuth(animated: animated)

        self.authCoordinator = authCoordinator
        self.mainTabBarCoordinator = nil
        self.forceAppUpdateCoordinator = nil
    }
    
    func startAuthCoordinator(animated: Bool) {
        logOutSettings()

        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            serviceFactory: serviceFactory)
        authCoordinator.delegate = self
        authCoordinator.start(animated: animated)

        self.authCoordinator = authCoordinator
        self.mainTabBarCoordinator = nil
        self.forceAppUpdateCoordinator = nil
    }

    func startAuthResetPasswordScreenCoordinator(resetPasswordToken: String, animated: Bool) {
        logOutSettings()

        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            serviceFactory: serviceFactory)
        authCoordinator.delegate = self
        authCoordinator.startResetPasswordScreen(resetPasswordToken: resetPasswordToken, animated: animated)

        self.authCoordinator = authCoordinator
        self.mainTabBarCoordinator = nil
        self.forceAppUpdateCoordinator = nil
    }

    func subscribe() {
        NotificationCenterHelper.TokenExpired.addObserver(self, selector: #selector(tokenExpired))
        NotificationCenterHelper.ForceAppUpdate.addObserver(self, selector: #selector(forceAppUpdate))
    }

    @objc func tokenExpired() {
        let loginStatus = UserData.shared.loginStatus
        UserData.shared.remove()
        
        switch loginStatus {
        case .autoLogin, .noLogin:
            AlertHelper.show(title: "Refreshing data", message: nil) { [weak self] _ in
                guard let self = self else { return }
                Task {
                    ActivityIndicatorHelper.shared.show()
                    do {
                        try await self.serviceFactory.makeDataLoader().loadData()
                    } catch {}
                    ActivityIndicatorHelper.shared.hide()
                    self.didLoginSuccessfully()
                }
            }
        case .primaryLogin, .secondaryLogin:
            AlertHelper.show(title: "Please, authorize to use app", message: nil) { [weak self] _ in
                self?.didSelectSignIn()
            }
        }
    }

    @objc func forceAppUpdate() {
        if forceAppUpdateCoordinator == nil {
            startForceAppUpdating(animated: false)
        }
    }
}

// MARK: - AuthCoordinatorDelegate
extension AppCoordinator: AuthCoordinatorDelegate {
    func didLoginSuccessfully() {
        startMainTabBarCoordinator(animated: true)
    }
}

// MARK: - MainTabBarDelegate
extension AppCoordinator: MainTabBarDelegate {
    func didSignout() {
        startAuthCoordinator(animated: true)
    }
    
    func didSelectSignIn() {
        startAuthCoordinator(animated: true)
    }
}

// MARK: Settings
private extension AppCoordinator {
    func logInSettings() {}

    func logOutSettings() {
        UserData.shared.remove()
    }
}
