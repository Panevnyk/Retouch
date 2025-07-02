//
//  GroupItemView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 19.10.2022.
//

import SwiftUI
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem

struct GroupItemView: View {
    var retouchGroup: PresentableRetouchGroup
    var isOpen: Bool
    var didSelectAction: (() -> Void)?

    var body: some View {
        Button {
            didSelectAction?()
        } label: {
            ZStack {
                Image("icCheckerPurple", bundle: Bundle.designSystem)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 14, height: 14)
                    .offset(x: 21, y: -21)
                    .isHidden(!retouchGroup.isSelected)

                VStack(spacing: 6) {
                    Image(retouchGroup.image, bundle: Bundle.designSystem)
                        .renderingMode(.template)
                        .foregroundColor(isOpen ? .kPurple : .black)

                    Text(retouchGroup.title)
                        .font(.kDescriptionText)
                        .foregroundColor(isOpen ? .kPurple : .black)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isOpen ? Color.kPurple : Color.clear, lineWidth: 1)
            )
        }
    }
}
