//
//  CurrentUserLoader.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 23.04.2021.
//

import RetouchNetworking
import RetouchDomain

public protocol CurrentUserLoaderProtocol: Sendable {
    func autoSigninUser() async throws -> User
    func loadUser() async throws -> User
}

public final class CurrentUserLoader: CurrentUserLoaderProtocol {
    // MARK: - Properties
    // Boundaries
    private let restApiManager: RestApiManager

    // MARK: - Inits
    public init(restApiManager: RestApiManager) {
        self.restApiManager = restApiManager
    }

    // MARK: - Load
    public func autoSigninUser() async throws -> User {
        let loginStatus = await MainActor.run { UserData.shared.loginStatus }
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
            UserData.save(userData: userData)
        }
        return userData.user
    }

    public func loadUser() async throws -> User {
        let method = AuthRestApiMethods.currentUser
        let user: User = try await restApiManager.call(method: method)
        await MainActor.run {
            UserData.save(user: user)
        }
        return user
    }
}
