//
//  AppDelegate.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk on 09.02.2021.
//

import UIKit
//import Firebase
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

// FIXME: - Firebase setup
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let serviceFactory = ServiceFactory.shared
//    lazy var pushNotificationService = serviceFactory.makePushNotificationService()
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup all DIs
        Container.configure()
        
//        If you're tracking in-app purchases, you must initialize your transaction observer in application:didFinishLaunchingWithOptions: before initializing Firebase, or your observer may not receive all purchase notifications.
        serviceFactory.makeIAPService().getProducts(completion: nil)

//        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = Constants.deepLinkURLScheme
//        FirebaseApp.configure()
//        serviceFactory.makeRemoteConfigService().setup()
//        pushNotificationService.setup()
        @Injected(\.analytics) var analytics
        analytics.setupUserID()
        
//        registerForPushNotifications(application: application)

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }
}

// MARK: - MessagingDelegate
//extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print(messaging)
//        #if DEBUG
//        print("\n\n-------------------------------------------------------------")
//        print("Token: \(fcmToken ?? "Nil value"), was get using notification.")
//        print("-------------------------------------------------------------\n\n")
//        #endif
//        pushNotificationService.fcmToken = fcmToken
//    }
//
//    // MARK: - Firebase Messaging
//    func registerForPushNotifications(application: UIApplication) {
//        Messaging.messaging().delegate = self
//
//        // For iOS 10 display notification (sent via APNS)
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(
//            options: [.alert, .badge, .sound],
//            completionHandler: {_, _ in })
//
//        application.registerForRemoteNotifications()
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        #if DEBUG
//        print("error: \(error)")
//        #endif
//    }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler:
//        @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        // Handle push when app is not active
//        if let appData = notification.request.content.userInfo as? [String: Any] {
//            pushNotificationService.handlePushNotification(appData: appData)
//        }
//        #if DEBUG
//        print("\n\n-------------------------------------------------------------")
//        print("Push notification recieved is not active")
//        print("-------------------------------------------------------------\n\n")
//        #endif
//        completionHandler([.alert, .badge, .sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        // Handle push when app is active
//        if let appData = response.notification.request.content.userInfo as? [String: Any] {
//            pushNotificationService.handlePushNotification(appData: appData)
//        }
//        #if DEBUG
//        print("\n\n-------------------------------------------------------------")
//        print("Push notification recieved is active")
//        print("-------------------------------------------------------------\n\n")
//        #endif
//        completionHandler()
//    }
//}
