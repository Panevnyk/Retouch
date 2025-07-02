//
//  PhotoButton.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk  on 24.08.2023.
//

import SwiftUI

public struct PhotoButton: View {
    public var action: (() -> Void)?
    
    public init(action: (() -> Void)?) {
        self.action = action
    }
    
    public var body: some View {
        HStack {
            Button {
                action?()
            } label: {
                Image("icCamera", bundle: .module)
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 36)
        .background(Color.kPurple)
        .cornerRadius(18)
    }
}

struct PhotoButton_Previews: PreviewProvider {
    static var previews: some View {
        PhotoButton(action: nil)
    }
}
