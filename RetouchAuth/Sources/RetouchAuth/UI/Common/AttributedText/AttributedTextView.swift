import SwiftUI

public struct AttributedTextView: UIViewRepresentable {
    public typealias UIViewType = AttributedUITextView
    
    private let viewModel: AttributedTextViewModel
    private let isLightStyle: Bool
    
    public init(
        viewModel: AttributedTextViewModel,
        isLightStyle: Bool
    ) {
        self.viewModel = viewModel
        self.isLightStyle = isLightStyle
    }
  
    public func makeUIView(context: Context) -> AttributedUITextView {
        let view = AttributedUITextView(
            viewModel: viewModel,
            isLightStyle: isLightStyle
        )
        return view
    }
    
    public func updateUIView(_ uiView: AttributedUITextView, context: Context) {}
}

struct AttributedTextView_Previews: PreviewProvider {
    static var previews: some View {
        AttributedTextView(
            viewModel: AttributedTextViewModel(
                content: []
            ),
            isLightStyle: false
        )
    }
}
