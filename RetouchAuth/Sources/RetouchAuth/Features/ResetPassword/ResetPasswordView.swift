import SwiftUI
import RetouchDomain
import RetouchDesignSystem
import RetouchNetworking

public struct ResetPasswordView: View {
    @ObservedObject
    private var viewModel: ResetPasswordViewModel
    
    public init(viewModel: ResetPasswordViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        bodyView
            .ignoresSafeArea()
            .onAppear(perform: viewModel.onAppear)
    }

    var bodyView: some View {
        VStack(spacing: 16) {
            AuthHeaderView(
                title: "Reset password",
                isBackButtonAvailable: true,
                backAction: viewModel.backAction
            )
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Create your new password and sign in")
                    .foregroundColor(.kGrayText)
                    .font(.kPlainText)
                    .padding(.top, 16)
                
                TextInput(
                    type: .password,
                    text: $viewModel.passwordText,
                    placeholder: "Password"
                )
                .setIsSecured(true)
                .setIsValid($viewModel.isPasswordValid)
                .frame(height: 64)
                
                MainButton(
                    text: "Sign in",
                    action: { Task { await viewModel.resetPasswordAction() } }
                )
                .isAvailable(viewModel.isPasswordValid)
                .padding(.top, 16)
                 
                UseAgreementsView(
                    delegate: viewModel.coordinatorDelegate
                )
                .padding(.top, 16)
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
}

struct AResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(
            viewModel: ResetPasswordViewModel(
                resetPasswordToken: "",
                restApiManager: RestApiManagerMock(),
                coordinatorDelegate: nil
            )
        )
    }
}
