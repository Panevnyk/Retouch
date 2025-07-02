//
//  ImageGalleryItemView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk  on 28.07.2023.
//

import SwiftUI
import RetouchUtils
import RetouchDesignSystem

struct HomeHistoryItemView: View {
    let viewModel: HomeHistoryItemViewModel
    let targetSize: CGSize
    var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            LoadableImage(
                loader: viewModel.imageLoader,
                imageUrl: viewModel.imageToShow,
                placeholder: (name: "icImagePlaceholder", bundle: .designSystem),
                targetSize: targetSize,
                action: action
            )
            .frame(width: targetSize.width, height: targetSize.height)
            .clipped()
            
            StatusBadgeView(
                title: viewModel.statusTitle,
                backgroundColor: viewModel.statusBackgroundColor
            )
            .padding([.top, .trailing], 3)
            .isHidden(viewModel.isStatusHidden)
        }
    }
}

struct HomeHistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHistoryItemView(
            viewModel: HomeHistoryItemViewModel(
                beforeImage: "Before",
                afterImage: "After",
                isPayed: false,
                isNew: false,
                status: .completed
            ),
            targetSize: CGSize(width: 30, height: 30),
            action: {}
        )
    }
}
