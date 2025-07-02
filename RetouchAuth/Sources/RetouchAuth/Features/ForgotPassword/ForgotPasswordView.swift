import SwiftUI
import RetouchDomain
import RetouchDesignSystem
import RetouchNetworking

public struct ForgotPasswordView: View {
    @ObservedObject
    private var viewModel: ForgotPasswordViewModel
    
    public init(viewModel: ForgotPasswordViewModel) {
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
                title: "Forgot password",
                isBackButtonAvailable: true,
                backAction: viewModel.backAction
            )
            
            VStack(alignment: .leading, spacing: 16) {
                Text("We will send reset password link to your email")
                    .foregroundColor(.kGrayText)
                    .font(.kPlainText)
                    .padding(.top, 16)
                
                TextInput(
                    type: .email,
                    text: $viewModel.emailText,
                    placeholder: "Email"
                )
                .setIsValid($viewModel.isEmailValid)
                .frame(height: 64)
                .padding(.top, 16)
                
                MainButton(
                    text: "Send",
                    action:  { Task { await viewModel.sendEmailAction() } }
                )
                .isAvailable(viewModel.isEmailValid)
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

struct AForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(
            viewModel: ForgotPasswordViewModel(
                restApiManager: RestApiManagerMock(),
                coordinatorDelegate: nil
            )
        )
    }
}
