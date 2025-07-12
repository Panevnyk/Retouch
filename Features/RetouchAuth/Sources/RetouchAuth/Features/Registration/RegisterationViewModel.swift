import Combine
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem
import RetouchNetworking
import FactoryKit

@MainActor
public protocol RegistrationViewCoordinatorDelegate: BaseAuthCoordinatorDelegate {
    func successRegistration()
}

@MainActor
public class RegisterationViewModel: ObservableObject {
    // MARK: - Properties
    // Boundaries
    @Injected(\.analytics) var analytics
    @Injected(\.notificationBanner) var notificationBanner
    @Injected(\.userDataService) var userDataService
    
    private let restApiManager: RestApiManager
    
    // ViewModels
    let signinWithAppleViewModel: SigninWithAppleViewModel
    
    // Delegates
    private(set) var coordinatorDelegate: RegistrationViewCoordinatorDelegate?
    
    // Published
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var isEmailValid: Bool = false
    @Published var isPasswordValid: Bool = false
    @Published var isSignUpAvailable: Bool = false
    
    private lazy var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    public init(
        restApiManager: RestApiManager,
        coordinatorDelegate: RegistrationViewCoordinatorDelegate?
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
        analytics.logScreen(.registration)
    }
    
    func signInAction() {
        coordinatorDelegate?.didSelectLogin()
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
                self.isSignUpAvailable = isEmailValid && isPasswordValid
            }
            .store(in: &subscriptions)
    }
}

// MARK: - RestApiable
extension RegisterationViewModel {
    public func registerAction() async {
        let parameters = SignupParameters(email: emailText, password: passwordText, deviceId: DeviceHelper.deviceId, freeGemsAvailable: DeviceHelper.freeGemsAvailable)
        let method = AuthRestApiMethods.signup(parameters)

        ActivityIndicatorHelper.shared.show()
        do {
            let userData: UserData = try await restApiManager.call(method: method)
            ActivityIndicatorHelper.shared.hide()
            userDataService.save(userData: userData)
            didRegisterSuccessfully()
        } catch {
            notificationBanner.showBanner(error)
        }
    }
    
    private func didRegisterSuccessfully() {
        coordinatorDelegate?.successRegistration()
    }
}

