import RetouchNetworking
import RetouchDomain
import RetouchUtils
import FactoryKit

public protocol CurrentUserLoaderProtocol: Sendable {
    func autoSigninUser() async throws -> User
    func loadUser() async throws -> User
}

public final class CurrentUserLoader: CurrentUserLoaderProtocol, @unchecked Sendable {
    // MARK: - Properties
    @Injected(\.userDataService) private var userDataService
    
    // Boundaries
    private let restApiManager: RestApiManager

    // MARK: - Inits
    public init(restApiManager: RestApiManager) {
        self.restApiManager = restApiManager
    }

    // MARK: - Load
    public func autoSigninUser() async throws -> User {
        let loginStatus = await MainActor.run { userDataService.loginStatus }
        switch loginStatus {
        case .noLogin, .autoLogin:
            return try await autoSigninUserWithDeviceId()
        case .primaryLogin, .secondaryLogin:
            return try await loadUser()
        }
    }
    
    private func autoSigninUserWithDeviceId() async throws -> User {
        let parameters = await SigninWithDeviceIdParameters(deviceId: DeviceHelper.deviceId, freeGemsAvailable: DeviceHelper.freeGemsAvailable)
        let method = AuthRestApiMethods.signinWithDeviceId(parameters)
        let userData: UserData = try await restApiManager.call(method: method)
        await MainActor.run {
            userDataService.save(userData: userData)
        }
        return userData.user
    }

    public func loadUser() async throws -> User {
        let method = AuthRestApiMethods.currentUser
        let user: User = try await restApiManager.call(method: method)
        await MainActor.run {
            userDataService.save(user: user)
        }
        return user
    }
}
