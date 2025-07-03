import SwiftUI

struct ClearButton: View {
    public let text: String
    public let action: () -> Void

    public var body: some View {
        Button(
            action: action,
            label: {
                ZStack {
                    Text(text)
                        .foregroundColor(Color.white)
                        .font(.kPlainText)
                }
                .frame(height: 36)
                .padding(.horizontal, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.white, lineWidth: 1)
                )
            }
        )
    }
    
    public func isAvailable(_ isAvailable: Bool) -> some View {
        self.disabled(!isAvailable)
            .opacity(isAvailable ? 1 : 0.6)
    }
}

struct AClearButton_Previews: PreviewProvider {
    static var previews: some View {
        ClearButton(text: "Button", action: {})
    }
}
