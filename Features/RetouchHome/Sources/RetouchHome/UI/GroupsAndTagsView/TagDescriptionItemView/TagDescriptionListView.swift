//
//  TagDescriptionListView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 26.10.2022.
//

import SwiftUI
import RetouchUtils
import RetouchDesignSystem

public struct TagDescriptionListView: View {
    public var preTitle: String?
    public var currentTitle: String?
    public var direction: AnimDirection

    public var action: ((_ index: Int) -> Void)?

    public var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            LazyHStack {
//                ForEach(0 ..< titles.count, id: \.self) { index in
//                    TagDescriptionItemView(title: titles[index], action: {
//                        action?(index)
//                    })
//                }
//            }
//            .padding([.leading, .trailing], 12)
//        }
//        .frame(height: 34)
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    TagDescriptionItemView(title: preTitle, action: {
                        action?(0)
                    })
                    .frame(width: proxy.size.width)
                    .transition(.slide)

                    TagDescriptionItemView(title: currentTitle, action: {
                        action?(0)
                    })
                    .frame(width: proxy.size.width)
                    .transition(.slide)
                }
            }
            .frame(height: 34)
        }
    }

    public enum AnimDirection {
        case left, right
    }
}

struct TagDescriptionListView_Previews: PreviewProvider {
    static var previews: some View {
        TagDescriptionListView(preTitle: "",
                               currentTitle: "",
                               direction: .left,
                               action: nil)
    }
}
