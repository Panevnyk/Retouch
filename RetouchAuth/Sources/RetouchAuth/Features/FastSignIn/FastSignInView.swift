import SwiftUI
import RetouchDomain
import RetouchDesignSystem
import RetouchNetworking

public struct FastSignInView: View {
    @ObservedObject
    private var viewModel: FastSignInViewModel
    
    public init(viewModel: FastSignInViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        bodyView
            .ignoresSafeArea()
            .onAppear(perform: viewModel.onAppear)
    }

    var bodyView: some View {
        ZStack(alignment: .topLeading) {
            Image("tutorialBGImage4", bundle: .designSystem)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Image("icBigHandFromTop", bundle: .designSystem)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            VStack(spacing: 16) {
                Spacer()
                
                SigninWithAppleView(
                    signinWithAppleViewModel: viewModel.signinWithAppleViewModel
                )
                .frame(height: 44)

                Text("OR")
                    .foregroundColor(.white)
                    .font(.kTitleText)
                
                AMainGrayButton(
                    text: "Use other sign in options",
                    action: viewModel.signInWithOtherOptionAction
                )
                
                UseAgreementsView(
                    delegate: viewModel.coordinatorDelegate,
                    isLightStyle: true
                )
                .frame(height: 44)
                .padding(.top, 16)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 64)
        }
    }
}

struct AFastSignInView_Previews: PreviewProvider {
    static var previews: some View {
        FastSignInView(
            viewModel: FastSignInViewModel(
                restApiManager: RestApiManagerMock(),
                coordinatorDelegate: nil
            )
        )
    }
}
