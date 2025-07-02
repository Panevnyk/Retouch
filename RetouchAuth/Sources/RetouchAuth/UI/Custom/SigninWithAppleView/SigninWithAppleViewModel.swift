import UIKit
import RetouchNetworking
import RetouchDomain
import RetouchDesignSystem
import FactoryKit

@MainActor
public protocol SigninWithAppleViewModelProtocol {
    func signin(appleUserId: String, fullName: String?, email: String?) async -> Bool
}

@MainActor
public final class SigninWithAppleViewModel: SigninWithAppleViewModelProtocol {
    // MARK: - Properties
    // Boundaries
    @Injected(\.analytics) var analytics
    @Injected(\.notificationBanner) var notificationBanner
    
    private let restApiManager: RestApiManager
    
    // Delegate
    public weak var delegate: BaseLoginCoordinatorDelegate?

    // MARK: - Inits
    public init(
        restApiManager: RestApiManager,
        delegate: BaseLoginCoordinatorDelegate?
    ) {
        self.restApiManager = restApiManager
        self.delegate = delegate
    }

    // MARK: - Public methods
    public func signin(appleUserId: String, fullName: String?, email: String?) async -> Bool {
        analytics.logAction(.fastSignInWithApple)

        let parameters = SigninWithAppleParameters(appleUserId: appleUserId,
                                                   fullName: fullName,
                                                   email: email,
                                                   deviceId: DeviceHelper.deviceId,
                                                   freeGemsAvailable: DeviceHelper.freeGemsAvailable)
        let method = AuthRestApiMethods.signinWithApple(parameters)

        do {
            let userData: UserData = try await restApiManager.call(method: method)
            UserData.save(userData: userData)
            delegate?.didLoginSuccessfully()
            return true
        } catch {
            notificationBanner.showBanner(error)
            return false
        }
    }
}
