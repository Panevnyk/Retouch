//
//  GroupView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 19.10.2022.
//

import SwiftUI
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem

public struct GroupsAndTagsView: View {
    @ObservedObject private var viewModel: GroupsAndTagsViewModel
    
    public init(retouchGroups: [PresentableRetouchGroup],
                openGroupIndex: Binding<Int?>,
                openTagIndex: Binding<Int?>) {
        self.viewModel = GroupsAndTagsViewModel(retouchGroups: retouchGroups,
                                                openGroupIndex: openGroupIndex,
                                                openTagIndex: openTagIndex)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            GroupListView(retouchGroups: viewModel.retouchGroups,
                          openIndex: $viewModel.openGroupIndex)
            
            if let openGroupIndex = viewModel.openGroupIndex {
                TagListView(retouchGroup: viewModel.retouchGroups[openGroupIndex],
                            openIndex: $viewModel.openTagIndex)
                    .transition(.move(edge: .bottom))
            }
            
            if let openGroupIndex = viewModel.openGroupIndex,
               let openTagIndex = viewModel.openTagIndex {
                TagDescriptionItemView(title: viewModel
                                            .retouchGroups[openGroupIndex]
                                            .tags[openTagIndex]
                                            .tagDescription,
                                       action: tagDescriptionAction)
                    .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity)
        .padding([.top, .bottom], 12)
        .background(.white)
    }

    func tagDescriptionAction() {
        viewModel.showTagDescription()
    }
}

struct GroupsAndTagsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsAndTagsView(retouchGroups: [],
                          openGroupIndex: .constant(0),
                          openTagIndex: .constant(0))
    }
}
