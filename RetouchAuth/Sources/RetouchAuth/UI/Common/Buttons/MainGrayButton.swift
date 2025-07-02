import SwiftUI

public struct AMainGrayButton: View {
    public let text: String
    public let action: () -> Void

    public var body: some View {
        Button(
            action: action,
            label: {
                ZStack {
                    Text(text)
                        .foregroundColor(.kGrayText)
                        .font(.kTitleBigText)
                        .padding(.horizontal, 16)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.kGrayText, lineWidth: 1)
                )
            }
        )
    }
    
    public func isAvailable(_ isAvailable: Bool) -> some View {
        self.disabled(!isAvailable)
            .opacity(isAvailable ? 1 : 0.6)
    }
}

struct AMainGrayButton_Previews: PreviewProvider {
    static var previews: some View {
        AMainGrayButton(text: "Button", action: {})
    }
}
