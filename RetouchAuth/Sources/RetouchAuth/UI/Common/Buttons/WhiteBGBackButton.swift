import SwiftUI

struct WhiteBGBackButton: View {
    public let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: {
                ZStack {
                    Image("icLeftArrowPurple", bundle: .designSystem)
                }
                .frame(width: 32, height: 32)
                .background(.white)
                .cornerRadius(16)
            }
        )
    }
}

struct WhiteBGBackButton_Previews: PreviewProvider {
    static var previews: some View {
        WhiteBGBackButton(action: {})
    }
}
