//
//  OrderButton.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 28.10.2022.
//

import SwiftUI

public struct OrderButton: View {
    public var action: (() -> Void)?

    public init(action: (() -> Void)?) {
        self.action = action
    }

    public var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                Text("Order")
                    .foregroundColor(.white)
                    .font(.kPlainBoldText)
                    .padding([.leading, .trailing], 16)
            }
            .frame(height: 32)
            .background(Color.kPurple)
            .cornerRadius(6)
        }
    }
    
    public func isAvailable(_ isAvailable: Bool) -> some View {
        self.disabled(!isAvailable)
            .opacity(isAvailable ? 1 : 0.6)
    }
}

struct OrderButton_Previews: PreviewProvider {
    static var previews: some View {
        OrderButton(action: nil)
    }
}
