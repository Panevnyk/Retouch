//
//  BackSwiftButton.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 17.09.2022.
//

import SwiftUI

public struct BackSwiftButton: View {
    public var action: (() -> Void)?

    public init(action: (() -> Void)? = nil) {
        self.action = action
    }

    public var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)

                Image("icLeftArrowPurple", bundle: .module)
            }
        }
    }
}

struct BackSwiftButton_Previews: PreviewProvider {
    static var previews: some View {
        BackSwiftButton()
    }
}
