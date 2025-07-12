import Foundation
import AuthenticationServices
import RetouchDomain
import Combine

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

public protocol UserDataService: Sendable, ObservableObject {
    var userDataPublisher: Published<UserData>.Publisher { get }
    var user: User { get }
    var isLogined: Bool { get }
    @MainActor
    var loginStatus: LoginStatus { get }
    
    func save(userData: UserData)
    func save(user: User)
    func remove()
    
    func update(gemCount: Int)
}

public final class UserDataServiceImpl: UserDataService, @unchecked Sendable {
    @Published
    public var userData: UserData
    public var userDataPublisher: Published<UserData>.Publisher { $userData }
    
    public var user: User { userData.user }
    public var isLogined: Bool { !userData.token.isEmpty }
    
    @MainActor
    public var loginStatus: LoginStatus {
        if !isLogined {
            return .noLogin
        } else if userData.user.isLoginedWithAppleOrEmail {
            return userData.user.deviceId == DeviceHelper.deviceId ? .primaryLogin : .secondaryLogin
        } else {
            return .autoLogin
        }
    }

    // MARK: - Init
    public init() {
        self.userData = UserDataServiceImpl.readDataFromKeychainService()
    }
}

// MARK: - Save
extension UserDataServiceImpl {
    public func save(userData: UserData) {
        self.userData = userData
        
        disableFreeGemsAvailableFeature()
        saveDataToKeychainService()
        didSigninAction()
    }

    public func save(user: User) {
        userData = UserData(token: userData.token, user: user)
        saveDataToKeychainService()
        didSigninAction()
    }
    
    public func remove() {
        userData = UserData.empty
        removeDataFromKeychainService()
        didSignoutAction()
    }
    
    public func update(gemCount: Int) {
        let user = User(
            id: user.id,
            deviceId: user.deviceId,
            appleUserId: user.appleUserId,
            fullName: user.fullName,
            email: user.email,
            gemCount: gemCount,
            freeGemCreditCount: user.freeGemCreditCount,
            fcmToken: user.fcmToken
        )
        userData = UserData(token: userData.token, user: user)
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

    func isUserAppleCredentialAuthorized(completion: ((_ isLogined: Bool) -> Void)?) {
        guard let appleUserId = userData.user.appleUserId else {
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

// MARK: - KeychainService
extension UserDataServiceImpl {
    func saveDataToKeychainService() {
        KeychainService.save(key: Constants.token, value: userData.token)
        
        KeychainService.save(key: Constants.userId, value: userData.user.id)
        KeychainService.save(key: Constants.deviceId, value: userData.user.deviceId ?? "")
        KeychainService.save(key: Constants.appleUserId, value: userData.user.appleUserId ?? "")
        KeychainService.save(key: Constants.fullName, value: userData.user.fullName ?? "")
        KeychainService.save(key: Constants.email, value: userData.user.email ?? "")
        KeychainService.save(key: Constants.gemCount, value: String(userData.user.gemCount))
        KeychainService.save(key: Constants.freeGemCreditCount, value: String(userData.user.freeGemCreditCount ?? 0))
        KeychainService.save(key: Constants.fcmToken, value: userData.user.fcmToken ?? "")
    }

    static func readDataFromKeychainService() -> UserData {
        let token = KeychainService.load(key: Constants.token) ?? ""
        
        let id = KeychainService.load(key: Constants.userId) ?? ""
        let deviceId = KeychainService.load(key: Constants.deviceId) ?? ""
        let appleUserId = KeychainService.load(key: Constants.appleUserId) ?? ""
        let fullName = KeychainService.load(key: Constants.fullName) ?? ""
        let email = KeychainService.load(key: Constants.email) ?? ""
        let gemCount = Int(KeychainService.load(key: Constants.gemCount) ?? "0") ?? 0
        let freeGemCreditCount = Int(KeychainService.load(key: Constants.freeGemCreditCount) ?? "0") ?? 0
        let fcmToken = KeychainService.load(key: Constants.fcmToken) ?? ""
        
        let user = User(
            id: id,
            deviceId: deviceId,
            appleUserId: appleUserId,
            fullName: fullName,
            email: email,
            gemCount: gemCount,
            freeGemCreditCount: freeGemCreditCount,
            fcmToken: fcmToken
        )
        
        return UserData(token: token, user: user)
    }

    func removeDataFromKeychainService() {
        KeychainService.remove(key: Constants.token)
        
        KeychainService.remove(key: Constants.userId)
        KeychainService.remove(key: Constants.deviceId)
        KeychainService.remove(key: Constants.appleUserId)
        KeychainService.remove(key: Constants.fullName)
        KeychainService.remove(key: Constants.email)
        KeychainService.remove(key: Constants.gemCount)
        KeychainService.remove(key: Constants.freeGemCreditCount)
        KeychainService.remove(key: Constants.fcmToken)
    }
}

extension UserDataServiceImpl {
    struct Constants {
        static let token = "token"
        static let fcmToken = "fcmToken"
        static let userId = "userId"
        static let email = "email"
        static let fullName = "fullName"
        static let deviceId = "deviceId"
        static let appleUserId = "appleUserId"
        static let gemCount = "gemCount"
        static let freeGemCreditCount = "freeGemCreditCount"
    }
}
