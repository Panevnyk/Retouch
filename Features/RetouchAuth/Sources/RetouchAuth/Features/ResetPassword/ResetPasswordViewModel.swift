import Combine
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem
import RetouchNetworking
import FactoryKit

@MainActor
public protocol ResetPasswordViewCoordinatorDelegate: UseAgreementsDelegate {
    func didLoginSuccessfully()
    func dissmiss()
}

@MainActor
public class ResetPasswordViewModel: ObservableObject {
    // MARK: - Properties
    // Boundaries
    @Injected(\.analytics) var analytics
    @Injected(\.notificationBanner) var notificationBanner
    @Injected(\.userDataService) var userDataService
    
    private let resetPasswordToken: String
    private let restApiManager: RestApiManager
    
    // Delegates
    private(set) var coordinatorDelegate: ResetPasswordViewCoordinatorDelegate?
    
    // Published
    @Published var passwordText: String = ""
    @Published var isPasswordValid: Bool = false
    
    private lazy var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    public init(
        resetPasswordToken: String,
        restApiManager: RestApiManager,
        coordinatorDelegate: ResetPasswordViewCoordinatorDelegate?
    ) {
        self.resetPasswordToken = resetPasswordToken
        self.restApiManager = restApiManager
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    // MARK: - Actions
    func onAppear() {
        analytics.logScreen(.resetPassword)
    }
    
    func backAction() {
        coordinatorDelegate?.dissmiss()
    }
}

// MARK: - RestApiable
extension ResetPasswordViewModel {
    public func resetPasswordAction() async {
        let parameters = ResetPasswordParameters(password: passwordText,
                                                 resetPasswordToken: resetPasswordToken)

        ActivityIndicatorHelper.shared.show()
        let method = AuthRestApiMethods.resetPassword(parameters)
        do {
            let userData: UserData = try await restApiManager.call(method: method)
            ActivityIndicatorHelper.shared.hide()
            userDataService.save(userData: userData)
            didLoginSuccessfully()
        } catch {
            notificationBanner.showBanner(error)
        }
    }
    
    private func didLoginSuccessfully() {
        coordinatorDelegate?.didLoginSuccessfully()
    }
}
