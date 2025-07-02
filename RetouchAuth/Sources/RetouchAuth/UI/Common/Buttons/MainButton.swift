import SwiftUI

public struct MainButton: View {
    public let text: String
    public let action: () -> Void

    public var body: some View {
        Button(
            action: action,
            label: {
                ZStack {
                    Text(text)
                        .foregroundColor(.white)
                        .font(.kTitleBigText)
                        .padding(.horizontal, 16)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.kPurple)
                .cornerRadius(6)
            }
        )
    }
    
    public func isAvailable(_ isAvailable: Bool) -> some View {
        self.disabled(!isAvailable)
            .opacity(isAvailable ? 1 : 0.6)
    }
}

struct AMainButton_Previews: PreviewProvider {
    static var previews: some View {
        MainButton(
            text: "Button",
            action: {}
        )
    }
}
