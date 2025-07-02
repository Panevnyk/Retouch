import SwiftUI

struct SecondaryButton: View {
    public let text: String
    public let action: () -> Void

    public var body: some View {
        Button(
            action: action,
            label: {
                ZStack {
                    Text(text)
                        .foregroundColor(Color.kPurple)
                        .font(.kPlainText)
                }
            }
        )
    }
    
    public func isAvailable(_ isAvailable: Bool) -> some View {
        self.disabled(!isAvailable)
            .opacity(isAvailable ? 1 : 0.6)
    }
}

struct ASecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton(text: "Button", action: {})
    }
}
