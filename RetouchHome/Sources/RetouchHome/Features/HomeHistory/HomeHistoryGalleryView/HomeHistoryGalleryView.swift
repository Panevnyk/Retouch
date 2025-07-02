//
//  ImageGalleryView.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk  on 28.07.2023.
//

import SwiftUI
import RetouchUtils
import RetouchDesignSystem

struct HomeHistoryGalleryView: View {
    private static let spacing: CGFloat = 2
    
    private let viewModels: [HomeHistoryItemViewModel]
    private var action: (_ item: Int) -> Void
    
    private let columns = [
        GridItem(spacing: HomeHistoryGalleryView.spacing),
        GridItem(spacing: HomeHistoryGalleryView.spacing),
        GridItem(spacing: HomeHistoryGalleryView.spacing)
    ]
    
    private var cellTargetSize: CGSize {
        let targetSide = ((UIScreen.main.bounds.width - (HomeHistoryGalleryView.spacing * 4)) / 3) 
        return CGSize(width: targetSide, height: targetSide)
    }
    
    public init(
        viewModels: [HomeHistoryItemViewModel],
        action: @escaping (_ item: Int) -> Void
    ) {
        self.viewModels = viewModels
        self.action = action
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: HomeHistoryGalleryView.spacing) {
                ForEach(0 ..< viewModels.count, id: \.self) { index in
                    HomeHistoryItemView(
                        viewModel: viewModels[index],
                        targetSize: cellTargetSize,
                        action: {
                            action(index)
                        }
                    )
                    .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        .padding([.all], HomeHistoryGalleryView.spacing)
    }
}

struct HomeHistoryGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHistoryGalleryView(
            viewModels: [],
            action: { _ in }
        )
    }
}
