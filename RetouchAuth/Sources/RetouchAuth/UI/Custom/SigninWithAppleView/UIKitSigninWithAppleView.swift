import UIKit
import RetouchDomain
import RetouchDesignSystem
import AuthenticationServices

public final class UIKitSigninWithAppleView: UIView {
    // MARK: - Properties
    public var viewModel: SigninWithAppleViewModelProtocol!

    // MARK: - initialize
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

// MARK: - SetupUI
extension UIKitSigninWithAppleView {
    func setupUI() {
        backgroundColor = .clear
        
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.cornerRadius = 6

        addSubviewUsingConstraints(view: authorizationButton)
    }
}

// MARK: - Public methods
extension UIKitSigninWithAppleView {
    func signinWithApple(appleUserId: String, fullName: String?, email: String?) async {
        ActivityIndicatorHelper.shared.show()
        _ = await viewModel.signin(appleUserId: appleUserId, fullName: fullName, email: email)
        ActivityIndicatorHelper.shared.hide()
    }
}

// MARK: - Actions
extension UIKitSigninWithAppleView {
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension UIKitSigninWithAppleView: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            var fullName: String? = nil
            if let credentialFullname = appleIDCredential.fullName,
               let givenName = credentialFullname.givenName,
               let familyName = credentialFullname.familyName {
                fullName = givenName + " " + familyName
            }
            let email = appleIDCredential.email

            Task {
                await signinWithApple(appleUserId: userIdentifier,
                                      fullName: fullName,
                                      email: email)
            }
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}
