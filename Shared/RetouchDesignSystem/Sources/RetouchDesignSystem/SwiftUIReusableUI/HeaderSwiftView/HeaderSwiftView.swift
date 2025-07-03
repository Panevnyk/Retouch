//
//  HeaderViewSwift.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 17.09.2022.
//

import SwiftUI

public struct HeaderSwiftView: View {
    public var title: String
    public var expandableTitle: String?
    public var expandableShowDetail: Binding<Bool>?
    public var isBackButtonHidden: Bool
    private var balanceAction: (() -> Void)?
    private var backAction: (() -> Void)?

    public init(title: String = "",
                expandableTitle: String? = nil,
                expandableShowDetail: Binding<Bool>? = nil,
                isBackButtonHidden: Bool = true,
                balanceAction: (() -> Void)? = nil,
                backAction: (() -> Void)? = nil) {
        self.title = title
        self.expandableTitle = expandableTitle
        self.expandableShowDetail = expandableShowDetail
        self.isBackButtonHidden = isBackButtonHidden
        self.balanceAction = balanceAction
        self.backAction = backAction
    }

    public var body: some View {
        HStack(spacing: 16) {
            BackSwiftButton(action: backAction)
                .isHidden(isBackButtonHidden)

            HStack {
                Text(title)
                    .font(.kBigTitleText)

                Spacer()

                ExpandableSwiftView(title: expandableTitle, showDetail: expandableShowDetail)

                Spacer()

                BalanceSwiftView(action: balanceAction)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 16)
        .frame(maxWidth: .infinity)
        .zIndex(100)
    }
}

struct HeaderSwiftView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderSwiftView()
    }
}
