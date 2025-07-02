//
//  UserData.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 12.11.2020.
//

import Foundation
import AuthenticationServices

public enum LoginStatus: Sendable {
    // Login only with DeviceId
    case autoLogin
    // Login with apple or email and with current DeviceId
    case primaryLogin
    // Login with apple or email and with OTHER DeviceId or withOUT DeviceId
    case secondaryLogin
    // No login
    case noLogin
}

public final class UserData: Decodable, @unchecked Sendable {
    public var token: String
    public var user: User

    public static let shared = UserData.empty

    // MARK: - Init
    public init(token: String, user: User) {
        self.token = token
        self.user = user
        
        readDataFromKeychainService()
    }
    
    func update(by userData: UserData) {
        self.token = userData.token
        self.user.update(by: userData.user)
    }
}

// MARK: - Save
public extension UserData {
    static func save(userData: UserData) {
        shared.disableFreeGemsAvailableFeature()
        shared.update(by: userData)
        shared.saveDataToKeychainService()
        shared.didSigninAction()
    }

    static func save(user: User) {
        shared.user.update(by: user)
        shared.saveDataToKeychainService()
        shared.didSigninAction()
    }
    
    func remove() {
        token = ""
        user.update(by: User.empty)
        removeDataFromKeychainService()
        didSignoutAction()
    }
    
    private func disableFreeGemsAvailableFeature() {
        if DeviceHelper.freeGemsAvailable {
            DeviceHelper.freeGemsAvailable = false
        }
    }
    
    private func didSigninAction() {
        NotificationCenterHelper.DidSigninAction.send()
    }
    
    private func didSignoutAction() {
        NotificationCenterHelper.DidSignoutAction.send()
    }
    
    var isLogined: Bool {
        return !token.isEmpty
    }

    @MainActor
    var loginStatus: LoginStatus {
        if !isLogined {
            return .noLogin
        } else if user.isLoginedWithAppleOrEmail {
            return user.deviceId == DeviceHelper.deviceId ? .primaryLogin : .secondaryLogin
        } else {
            return .autoLogin
        }
    }

    func isUserAppleCredentialAuthorized(completion: ((_ isLogined: Bool) -> Void)?) {
        guard let appleUserId = user.appleUserId else {
            completion?(false)
            return
        }
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: appleUserId) { (credentialState, error) in
             switch credentialState {
                case .authorized:
                    completion?(true)
                case .revoked:
                    completion?(false)
                case .notFound:
                    completion?(false)
                default:
                    completion?(false)
             }
        }
    }
}

// MARK: - Empty
public extension UserData {
    static var empty: UserData {
        return UserData(token: "", user: User.empty)
    }
}

// MARK: - KeychainService
extension UserData {
    func saveDataToKeychainService() {
        KeychainService.save(key: Constants.token, value: token)
        user.saveDataToKeychainService()
    }

    func readDataFromKeychainService() {
        token = KeychainService.load(key: Constants.token) ?? ""
        user.readDataFromKeychainService()
    }

    func removeDataFromKeychainService() {
        KeychainService.remove(key: Constants.token)
        user.removeDataFromKeychainService()
    }
}

// MARK: - NotificationCenterHelper
enum NotificationCenterHelper {}

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
