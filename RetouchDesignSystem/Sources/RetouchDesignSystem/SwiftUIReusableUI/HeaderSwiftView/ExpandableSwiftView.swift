//
//  ExpandableSwiftView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 17.09.2022.
//

import SwiftUI

public struct ExpandableSwiftView: View {
    private var title: String
    private var showDetail: Binding<Bool>

    init?(title: String?, showDetail: Binding<Bool>?) {
        guard let title = title, let showDetail = showDetail else { return nil }
        self.title = title
        self.showDetail = showDetail
    }

    public var body: some View {
        Button {
            showDetail.wrappedValue.toggle()
        } label: {
            HStack(spacing: 6) {
                Text(title)
                    .font(.kTitleBigText)
                    .foregroundColor(.black)

                Image("icDownArrowBlack", bundle: .module)
                    .rotationEffect(.degrees(showDetail.wrappedValue ? 180 : 0))
                    .animation(.easeInOut, value: showDetail.wrappedValue)
            }
        }
    }
}
