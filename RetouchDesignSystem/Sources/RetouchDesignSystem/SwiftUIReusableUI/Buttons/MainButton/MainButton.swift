//
//  MainButton.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk  on 27.08.2023.
//

import SwiftUI

public struct MainButton: View {
    private let title: String
    private let action: (() -> Void)?

    public init(
        title: String,
        action: (() -> Void)?
    ) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                Text(title)
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

struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        MainButton(
            title: "Title",
            action: nil
        )
    }
}
