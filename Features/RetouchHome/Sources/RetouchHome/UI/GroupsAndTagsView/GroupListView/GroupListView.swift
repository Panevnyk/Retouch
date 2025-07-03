//
//  GroupListView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 19.10.2022.
//

import SwiftUI
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem

struct GroupListView: View {
    @ObservedObject private var viewModel: GroupListViewModel

    init(retouchGroups: [PresentableRetouchGroup],
         openIndex: Binding<Int?>) {
        self.viewModel = GroupListViewModel(retouchGroups: retouchGroups,
                                            openIndex: openIndex)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(0 ..< viewModel.retouchGroups.count, id: \.self) { index in
                    GroupItemView(retouchGroup: viewModel.retouchGroups[index],
                                  isOpen: index == viewModel.openIndex) {
                        viewModel.didSelectGroupItem(by: index)
                    }
                }
            }
            .padding([.leading, .trailing], 12)
        }
        .frame(height: 64)
    }
}
