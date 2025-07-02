//
//  PopupView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 05.10.2022.
//

import SwiftUI

public extension View {
    func popup<Content: View>(show: Binding<Bool>,
                              insets: UIEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24),
                              heightMultiplier: CGFloat = 0.9,
                              content: @escaping () -> Content) -> some View {
        return self.overlay {
            if show.wrappedValue {
                GeometryReader { geo in
                    ZStack {
                        content()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .frame(width: geo.size.width - insets.left - insets.right,
                           height: geo.size.height * heightMultiplier,
                           alignment: .center)
                    .background(Color.kBackground)
                    .cornerRadius(6)
                    .border(Color.kSeparatorGray, width: 1)
                    .padding(.leading, insets.left)
                }
            }
        }
    }
}

