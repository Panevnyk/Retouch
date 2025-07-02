//
//  SceneDelegate.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 09.02.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let serviceFactory = ServiceFactory.shared
    lazy var appCoordinator: AppCoordinator? = AppCoordinator(window: window, serviceFactory: serviceFactory)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window

            // either one will work
            let urlToOpen = connectionOptions.urlContexts.first?.url ?? connectionOptions.userActivities.first?.webpageURL
            if let deepLinkType = makeDeepLinkType(from: urlToOpen) {
                appCoordinator?.start(deepLinkType: deepLinkType)
            } else {
                appCoordinator?.start()
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        // first launch after install
        handleURL(url)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // when in background mode
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            handleURL(userActivity.webpageURL)
        }
    }

    private func handleURL(_ url: URL?) {
        guard let deepLinkType = makeDeepLinkType(from: url) else { return }
        appCoordinator?.start(deepLinkType: deepLinkType)
    }

    private func makeDeepLinkType(from url: URL?) -> DeepLinkType? {
        guard let url = url else { return nil }
        return serviceFactory.makeDeepLinkHelper().deepLinkType(for: url)
    }
}
