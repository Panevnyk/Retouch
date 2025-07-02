import UIKit
import RetouchDomain
import RetouchDesignSystem
import RetouchNetworking
import FactoryKit

@MainActor
public protocol AFastSignInViewCoordinatorDelegate: BaseLoginCoordinatorDelegate, UseAgreementsDelegate {
    func didSelectUseOtherSigninOptions()
}

@MainActor
public final class FastSignInViewModel: ObservableObject {
    // MARK: - Properties
    // Boundaries
    @Injected(\.analytics) var analytics
    
    private let restApiManager: RestApiManager
    
    // ViewModels
    let signinWithAppleViewModel: SigninWithAppleViewModel
    
    // Delegates
    private(set) var coordinatorDelegate: AFastSignInViewCoordinatorDelegate?

    // MARK: - Inits
    public init(
        restApiManager: RestApiManager,
        coordinatorDelegate: AFastSignInViewCoordinatorDelegate?
    ) {
        self.restApiManager = restApiManager
        self.coordinatorDelegate = coordinatorDelegate
        
        signinWithAppleViewModel = SigninWithAppleViewModel(
            restApiManager: restApiManager,
            delegate: coordinatorDelegate
        )
    }
    
    // MARK: - Actions
    func onAppear() {
        analytics.logScreen(.fastSignIn)
    }
    
    func signInWithOtherOptionAction() {
        coordinatorDelegate?.didSelectUseOtherSigninOptions()
        analytics.logAction(.fastSignInOtherOptions)
    }
}
