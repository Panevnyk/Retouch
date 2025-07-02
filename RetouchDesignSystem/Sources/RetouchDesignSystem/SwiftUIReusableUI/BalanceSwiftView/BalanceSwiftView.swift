//
//  BalanceSwiftView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 17.09.2022.
//

import SwiftUI

public struct BalanceSwiftView: View {
    @ObservedObject public var viewModel: BalanceSwiftViewModel
    private var action: (() -> Void)?

    public init(action: (() -> Void)?) {
        self.action = action
        self.viewModel = BalanceSwiftViewModel()
    }

    public var body: some View {
        Button {
            action?()
        } label: {
            ZStack(alignment: .trailing) {
                HStack(spacing: 6) {
                    Text(viewModel.gemCount)
                        .foregroundColor(.kPurple)
                        .font(.kPlainBigText)

                    Image("icDiamondPurple", bundle: .module)
                }

                Image("icFreeBadge", bundle: .module)
                    .frame(width: 40, height: 34)
                    .offset(x: 24, y: 30)
            }
        }
        .padding([.leading, .trailing], 12)
        .frame(height: 32)
        .overlay(Capsule()
            .stroke(Color.kPurple, lineWidth: 1))
    }
}

struct BalanceSwiftView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceSwiftView(action: nil)
    }
}
