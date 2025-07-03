import SwiftUI

struct BackButton: View {
    public let action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                ZStack {
                    Image("icLeftArrowPurple", bundle: .designSystem)
                }
                .frame(width: 32, height: 32)
            }
        )
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(action: {})
    }
}
