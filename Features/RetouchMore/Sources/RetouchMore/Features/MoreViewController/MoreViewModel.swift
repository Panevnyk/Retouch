//
//  MoreViewModel.swift
//  RetouchMore
//
//  Created by Vladyslav Panevnyk on 08.03.2021.
//

import UIKit
import RetouchDomain
import RetouchUtils
import RetouchNetworking
import RetouchDesignSystem

@MainActor
public protocol MoreViewModelProtocol {
    var isUserLoginedWithSecondaryLogin: Bool { get }
    var isRemoveAccountAvailable: Bool { get }
    var signInOutTitle: String? { get }
    var signInDescriptionTitle: String? { get }
    var userIdTitle: String { get }
    
    func removeAccount() async
    func signOut() async

    func makeTermsAndConditionsViewModel() -> InfoViewModelProtocol
    func makePrivacyPolicyViewModel() -> InfoViewModelProtocol
}

@MainActor
public final class MoreViewModel: MoreViewModelProtocol, Sendable {
    // MARK: - Properties
    private let restApiManager: RestApiManager
    private let dataLoader: DataLoaderProtocol

    // MARK: - Init
    nonisolated public init(restApiManager: RestApiManager, dataLoader: DataLoaderProtocol) {
        self.restApiManager = restApiManager
        self.dataLoader = dataLoader
    }

    // MARK: - Public methods
    public var isUserLoginedWithSecondaryLogin: Bool {
        UserData.shared.loginStatus == .secondaryLogin
    }
    
    public var isRemoveAccountAvailable: Bool {
        UserData.shared.loginStatus == .primaryLogin
        || UserData.shared.loginStatus == .secondaryLogin
    }
    
    public var signInOutTitle: String? {
        switch UserData.shared.loginStatus {
        case .autoLogin, .noLogin: return "Sign in"
        case .primaryLogin: return "Sign in to other account"
        case .secondaryLogin: return "Sign out"
        }
    }
    
    public var signInDescriptionTitle: String? {
        UserData.shared.loginStatus == .autoLogin || UserData.shared.loginStatus == .noLogin
            ? "Signing up helps you to save your credits and ready photos\nin case of loosing or changing mobile" : nil
    }
    
    public var userIdTitle: String {
        "UserId: " + UserData.shared.user.id
    }
    
    public func signOut() async {
        let method = AuthRestApiMethods.signout
        let _: String? = try? await restApiManager.call(method: method)
        
        UserData.shared.remove()
        try? await dataLoader.loadData()
    }
    
    public func removeAccount() async {
        let method = AuthRestApiMethods.removeAccount
        let _: String? = try? await restApiManager.call(method: method)
        await signOut()
    }
    
    public func makeTermsAndConditionsViewModel() -> InfoViewModelProtocol {
        return TermsAndConditionsViewModel()
    }

    public func makePrivacyPolicyViewModel() -> InfoViewModelProtocol {
        return PrivacyPolicyViewModel()
    }
}
