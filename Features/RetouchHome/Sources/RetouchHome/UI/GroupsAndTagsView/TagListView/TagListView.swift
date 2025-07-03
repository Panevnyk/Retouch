//
//  TagListView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 19.10.2022.
//

import SwiftUI
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem

struct TagListView: View {
    @ObservedObject private var viewModel: TagListViewModel

    init(retouchGroup: PresentableRetouchGroup,
         openIndex: Binding<Int?>) {
        self.viewModel = TagListViewModel(retouchGroup: retouchGroup,
                                          openIndex: openIndex)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(0 ..< viewModel.retouchGroup.tags.count, id: \.self) { index in
                    let isSelected = viewModel.retouchGroup.selectedRetouchTags
                        .map({ $0.id })
                        .contains(viewModel.retouchGroup.tags[index].id)
                    TagItemView(title: viewModel.retouchGroup.tags[index].title,
                                isSelected: isSelected,
                                isOpen: index == viewModel.openIndex) {
                        viewModel.didSelectTagItem(by: index)
                    }
                }
            }
            .padding([.leading, .trailing], 12)
        }
        .frame(height: 40)
    }
}
