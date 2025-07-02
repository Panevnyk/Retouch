import SwiftUI

public struct AuthHeaderView: View {
    private let title: String
    private let isBackButtonAvailable: Bool
    private var backAction: (() -> Void)?
    
    public init(
        title: String,
        isBackButtonAvailable: Bool = false,
        backAction: (() -> Void)?
    ) {
        self.title = title
        self.isBackButtonAvailable = isBackButtonAvailable
        self.backAction = backAction
    }
    
    public var body: some View {
        ZStack {
            Image("icAuthHeader", bundle: .designSystem)
                .resizable()
                .frame(maxWidth: .infinity)
            
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    WhiteBGBackButton { backAction?() }
                        .isHidden(!isBackButtonAvailable)
                    
                    Text(title)
                        .foregroundColor(.white)
                        .font(.kBigTitleText)
                    
                    Spacer()
                }
                .padding(.leading, 16)
                .frame(height: 56)
            }
        }
        .frame(height: 124)
        .frame(maxWidth: .infinity)
    }
}

struct AuthHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AuthHeaderView(
            title: "Login",
            isBackButtonAvailable: true,
            backAction: nil
        )
    }
}
