//
//  PriceSwiftView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 18.10.2022.
//

import SwiftUI

public struct PriceSwiftView: View {
    @Binding var price: Int

    public init(price: Binding<Int>) {
        self._price = price
    }

    public var body: some View {
        HStack(spacing: 6) {
            Text(String(price))
                .foregroundColor(.kPurple)
                .font(.kPlainText)

            Image("icDiamondPurple", bundle: Bundle.module)
        }
    }
}

struct PriceSwiftView_Previews: PreviewProvider {
    static var previews: some View {
        PriceSwiftView(price: .constant(15))
    }
}
