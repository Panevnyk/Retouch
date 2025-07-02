//
//  NotificationCenterHelper.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 16.03.2021.
//

import Foundation

public struct NotificationCenterHelper {}

// MARK: - TokenExpired
extension NotificationCenterHelper {
    public struct TokenExpired {
        private static let name = "TokenExpiredNotificationIdentifier"

        public static func send() {
            NotificationCenter.default.post(name: Notification.Name(TokenExpired.name), object: nil)
        }

        public static func addObserver(_ observer: Any, selector: Selector) {
            NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(TokenExpired.name), object: nil)
        }

        public static func removeObserver(_ observer: Any) {
            NotificationCenter.default.removeObserver(observer, name: Notification.Name(TokenExpired.name), object: nil)
        }
    }
}

// MARK: - TokenExpired
extension NotificationCenterHelper {
    public struct ForceAppUpdate {
        private static let name = "ForceAppUpdateNotificationIdentifier"

        public static func send() {
            NotificationCenter.default.post(name: Notification.Name(ForceAppUpdate.name), object: nil)
        }

        public static func addObserver(_ observer: Any, selector: Selector) {
            NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(ForceAppUpdate.name), object: nil)
        }

        public static func removeObserver(_ observer: Any) {
            NotificationCenter.default.removeObserver(observer, name: Notification.Name(ForceAppUpdate.name), object: nil)
        }
    }
}

// MARK: - DidSigninAction
extension NotificationCenterHelper {
    public struct DidSigninAction {
        private static let name = "DidSigninActionNotificationIdentifier"

        public static func send() {
            NotificationCenter.default.post(name: Notification.Name(DidSigninAction.name), object: nil)
        }

        public static func addObserver(_ observer: Any, selector: Selector) {
            NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(DidSigninAction.name), object: nil)
        }

        public static func removeObserver(_ observer: Any) {
            NotificationCenter.default.removeObserver(observer, name: Notification.Name(DidSigninAction.name), object: nil)
        }
    }
}

// MARK: - DidSignoutAction
extension NotificationCenterHelper {
    public struct DidSignoutAction {
        private static let name = "DidSignoutActionNotificationIdentifier"

        public static func send() {
            NotificationCenter.default.post(name: Notification.Name(DidSignoutAction.name), object: nil)
        }

        public static func addObserver(_ observer: Any, selector: Selector) {
            NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(DidSignoutAction.name), object: nil)
        }

        public static func removeObserver(_ observer: Any) {
            NotificationCenter.default.removeObserver(observer, name: Notification.Name(DidSignoutAction.name), object: nil)
        }
    }
}
