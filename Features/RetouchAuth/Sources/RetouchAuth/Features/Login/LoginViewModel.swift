import Combine
import RetouchDomain
import RetouchDesignSystem
import RetouchNetworking
import FactoryKit

@MainActor
public protocol BaseLoginCoordinatorDelegate: AnyObject {
    func didLoginSuccessfully()
}

@MainActor
public protocol BaseAuthCoordinatorDelegate: BaseLoginCoordinatorDelegate, UseAgreementsDelegate {
    func didSelectLogin()
    func didSelectSignUp()
}

@MainActor
public protocol LoginViewCoordinatorDelegate: BaseAuthCoordinatorDelegate {
    func didSelectForgotPassword()
}

@MainActor
public class LoginViewModel: ObservableObject {
    // MARK: - Properties
    // Boundaries
    @Injected(\.analytics) var analytics
    @Injected(\.notificationBanner) var notificationBanner
    
    private let restApiManager: RestApiManager
    
    // ViewModels
    let signinWithAppleViewModel: SigninWithAppleViewModel
    
    // Delegates
    private(set) var coordinatorDelegate: LoginViewCoordinatorDelegate?
    
    // Published
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var isEmailValid: Bool = false
    @Published var isPasswordValid: Bool = false
    @Published var isSignInAvailable: Bool = false
    
    private lazy var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    public init(
        restApiManager: RestApiManager,
        defaultEmail: String? = nil,
        coordinatorDelegate: LoginViewCoordinatorDelegate?
    ) {
        self.restApiManager = restApiManager
        self.coordinatorDelegate = coordinatorDelegate
        
        signinWithAppleViewModel = SigninWithAppleViewModel(
            restApiManager: restApiManager,
            delegate: coordinatorDelegate
        )
        
        bindData()
    }
    
    // MARK: - Actions
    func onAppear() {
        analytics.logScreen(.login)
    }
    
    func signUpAction() {
        coordinatorDelegate?.didSelectSignUp()
    }
    
    func forgotPasswordAction() {
        coordinatorDelegate?.didSelectForgotPassword()
    }
    
    // MARK: - Bind
    private func bindData() {
        Publishers
            .CombineLatest(
                $isEmailValid,
                $isPasswordValid
            )
            .sink { [weak self] (isEmailValid, isPasswordValid) in
                guard let self = self else { return }
                self.isSignInAvailable = isEmailValid && isPasswordValid
            }
            .store(in: &subscriptions)
    }
}

// MARK: - RestApiable
extension LoginViewModel {
    public func loginAction() async {
        let parameters = SigninParameters(email: emailText, password: passwordText)
        let method = AuthRestApiMethods.signin(parameters)

        ActivityIndicatorHelper.shared.show()
        do {
            let userData: UserData = try await restApiManager.call(method: method)
            ActivityIndicatorHelper.shared.hide()
            UserData.save(userData: userData)
            didLoginSuccessfully()
        } catch {
            notificationBanner.showBanner(error)
        }
    }
    
    private func didLoginSuccessfully() {
        coordinatorDelegate?.didLoginSuccessfully()
    }
}

