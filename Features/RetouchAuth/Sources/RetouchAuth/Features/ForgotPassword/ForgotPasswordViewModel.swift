import Combine
import RetouchDomain
import RetouchDesignSystem
import RetouchNetworking
import FactoryKit

@MainActor
public protocol ForgotPasswordViewCoordinatorDelegate: UseAgreementsDelegate {
    func didSelectLoginWith(email: String)
    func dissmiss()
}

@MainActor
public class ForgotPasswordViewModel: ObservableObject {
    // MARK: - Properties
    // Boundaries
    @Injected(\.analytics) var analytics
    @Injected(\.notificationBanner) var notificationBanner
    
    private let restApiManager: RestApiManager
    
    // Delegates
    private(set) var coordinatorDelegate: ForgotPasswordViewCoordinatorDelegate?
    
    // Published
    @Published var emailText: String = ""
    @Published var isEmailValid: Bool = false
    
    private lazy var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    public init(
        restApiManager: RestApiManager,
        coordinatorDelegate: ForgotPasswordViewCoordinatorDelegate?
    ) {
        self.restApiManager = restApiManager
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    // MARK: - Actions
    func onAppear() {
        analytics.logScreen(.forgotPassword)
    }
    
    func backAction() {
        coordinatorDelegate?.dissmiss()
    }
}

// MARK: - RestApiable
extension ForgotPasswordViewModel {
    public func sendEmailAction() async {
        let parameters = ForgotPasswordParameters(email: emailText)
        ActivityIndicatorHelper.shared.show()
        let method = AuthRestApiMethods.forgotPassword(parameters)
        do {
            let value: String = try await restApiManager.call(method: method)
            ActivityIndicatorHelper.shared.hide()
            didSelectLoginWith(email: emailText)
        } catch {
            notificationBanner.showBanner(error)
        }
    }
    
    private func didSelectLoginWith(email: String) {
        AlertHelper.show(title: nil, message: "Temporary password has been sent to your email", action: { (_) in
            self.coordinatorDelegate?.didSelectLoginWith(email: email)
        })
    }
}
