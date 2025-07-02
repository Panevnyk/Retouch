//
//  TagListViewModel.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 19.10.2022.
//

import SwiftUI
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem

final class TagListViewModel: ObservableObject {
    let retouchGroup: PresentableRetouchGroup
    @Binding var openIndex: Int?

    init(retouchGroup: PresentableRetouchGroup,
         openIndex: Binding<Int?>) {
        self.retouchGroup = retouchGroup
        self._openIndex = openIndex
    }

    func didSelectTagItem(by index: Int) {
        let newOpenIndex = openIndex == index ? nil : index
        retouchGroup.update(by: index, isOpened: newOpenIndex != nil)
        openIndex = newOpenIndex
    }
}
