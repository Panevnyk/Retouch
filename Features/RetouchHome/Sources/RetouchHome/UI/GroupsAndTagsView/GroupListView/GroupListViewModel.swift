//
//  GroupListViewModel.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 19.10.2022.
//

import SwiftUI
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem

@MainActor
final class GroupListViewModel: ObservableObject {
    let retouchGroups: [PresentableRetouchGroup]
    @Binding var openIndex: Int?

    init(retouchGroups: [PresentableRetouchGroup],
         openIndex: Binding<Int?>) {
        self.retouchGroups = retouchGroups
        self._openIndex = openIndex
    }

    func didSelectGroupItem(by index: Int) {
        openIndex = openIndex == index ? nil : index
    }
}
