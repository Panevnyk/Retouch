//
//  StatusBadgeView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk  on 23.08.2023.
//

import SwiftUI

public struct StatusBadgeView: View {
    public let title: String
    public let backgroundColor: Color
    
    public init(
        title: String,
        backgroundColor: Color
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        VStack {
            Text(title)
                .font(.kDescriptionMediumText)
                .foregroundColor(.white)
                .padding(.horizontal, 7)
        }
        .frame(height: 24)
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

struct StatusBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBadgeView(
            title: "Confirmed",
            backgroundColor: Color(uiColor: .kBlue)
        )
    }
}
