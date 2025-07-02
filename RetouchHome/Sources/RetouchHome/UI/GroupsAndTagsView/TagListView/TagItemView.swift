//
//  TagItemView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 19.10.2022.
//

import SwiftUI
import RetouchUtils
import RetouchDesignSystem

struct TagItemView: View {
    var title: String
    var isSelected: Bool
    var isOpen: Bool
    var didSelectAction: (() -> Void)?

    var body: some View {
        Button {
            didSelectAction?()
        } label: {
            VStack(alignment: .center, spacing: 0) {
                ZStack {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.kDescriptionText)
                            .foregroundColor(isOpen ? .kPurple : .black)

                        Image("icCheckerPurple", bundle: Bundle.designSystem)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 12, height: 12)
                            .isHidden(!isSelected, remove: false)
                    }
                    .padding([.leading, .trailing], 6)
                }
                .frame(height: 32)
                .background(isOpen ? Color.kPurpleAlpha10 : Color.clear)
                .cornerRadius(6)

                Triangle()
                    .fill(isOpen ? Color.kPurpleAlpha10 : Color.clear)
                    .frame(width: 14, height: 8)
            }
        }
    }
}
