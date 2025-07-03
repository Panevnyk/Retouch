//
//  TagDescriptionItemView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 26.10.2022.
//

import SwiftUI
import RetouchUtils
import RetouchDesignSystem

public struct TagDescriptionItemView: View {
    public var title: String?
    public var action: (() -> Void)?

    public var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 10) {
                Image("icPencil", bundle: Bundle.designSystem)

                Text(presentableTitle)
                    .foregroundColor(.kGrayText)
                    .font(.kPlainText)

                Spacer()
            }
            .padding(.leading, 10)
        }
        .frame(height: 34)
        .background(Color.kInputBackgroundGrey)
        .cornerRadius(6)
        .padding([.leading, .trailing], 12)
    }

    private var presentableTitle: String {
        if let title = title, !title.isEmpty {
            return title
        }

        return "Please, describe what you would like to change"
    }
}
