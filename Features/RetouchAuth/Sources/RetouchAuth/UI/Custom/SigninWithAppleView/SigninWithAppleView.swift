import SwiftUI
import RetouchDomain
import RetouchDesignSystem
import RetouchNetworking

public struct SigninWithAppleView: UIViewRepresentable {
    public typealias UIViewType = UIKitSigninWithAppleView
    
    private let signinWithAppleViewModel: SigninWithAppleViewModel
    
    public init(signinWithAppleViewModel: SigninWithAppleViewModel) {
        self.signinWithAppleViewModel = signinWithAppleViewModel
    }
  
    public func makeUIView(context: Context) -> UIKitSigninWithAppleView {
        let view = UIKitSigninWithAppleView()
        view.viewModel = signinWithAppleViewModel
        return view
    }
    
    public func updateUIView(_ uiView: UIKitSigninWithAppleView, context: Context) {}
}

struct SigninWithAppleView_Previews: PreviewProvider {
    static var previews: some View {
        SigninWithAppleView(
            signinWithAppleViewModel: SigninWithAppleViewModel(
                restApiManager: RestApiManagerMock(),
                delegate: nil
            )
        )
    }
}
