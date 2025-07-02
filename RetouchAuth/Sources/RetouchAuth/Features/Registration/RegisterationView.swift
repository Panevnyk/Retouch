import SwiftUI
import RetouchDomain
import RetouchDesignSystem
import RetouchNetworking

public struct RegisterationView: View {
    @ObservedObject
    private var viewModel: RegisterationViewModel
    
    public init(viewModel: RegisterationViewModel) {
        self.viewModel = viewModel
    }
    
//    @FocusState
//    var focusedField: Field?
//    enum Field: Hashable {
//        case email, password
//    }
    
    public var body: some View {
        bodyView
            .ignoresSafeArea()
            .onAppear(perform: viewModel.onAppear)
    }

    var bodyView: some View {
        VStack(spacing: 16) {
            AuthHeaderView(
                title: "Registration",
                backAction: nil
            )
            
            VStack(spacing: 16) {
                TextInput(
                    type: .email,
                    text: $viewModel.emailText,
                    placeholder: "Email"
                )
                .setIsValid($viewModel.isEmailValid)
//                .focused($focusedField, equals: .email)
//                .onSubmit { focusedField = .password }
                .frame(height: 64)
                .padding(.top, 16)
                
                TextInput(
                    type: .password,
                    text: $viewModel.passwordText,
                    placeholder: "Password"
                )
                .setIsSecured(true)
                .setIsValid($viewModel.isPasswordValid)
//                .focused($focusedField, equals: .password)
//                .onSubmit { focusedField = nil }
                .frame(height: 64)
                
                MainButton(
                    text: "Sign up",
                    action: { Task { await viewModel.registerAction() } }
                )
                .isAvailable(viewModel.isSignUpAvailable)
                .padding(.top, 32)
                 
                Text("OR")
                    .foregroundColor(.kTextDarkGray)
                    .font(.kTitleText)
                
                SigninWithAppleView(
                    signinWithAppleViewModel: viewModel.signinWithAppleViewModel
                )
                .frame(height: 44)
                
                UseAgreementsView(
                    delegate: viewModel.coordinatorDelegate
                )
                .padding(.top, 16)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text("I already have an account")
                        .foregroundColor(.kGrayText)
                        .font(.kPlainText)
                    
                    SecondaryButton(
                        text: "Sign in",
                        action: viewModel.signInAction
                    )
                    
                    Spacer()
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
}

struct ARegisterationView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterationView(
            viewModel: RegisterationViewModel(
                restApiManager: RestApiManagerMock(),
                coordinatorDelegate: nil
            )
        )
    }
}
