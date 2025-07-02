//
//  NotificationHeaderView.swift
//  RetouchHome
//
//  Created by Panevnyk Vlad on 28.01.2022.
//

import UIKit

final class NotificationHeaderView: UICollectionReusableView {
    // MARK: - Properties
    @IBOutlet private var notificationView: NotificationView!
    
    // MARK: - setup
    func setup(viewModel: NotificationBannerViewModel) {
        notificationView.setup(viewModel: viewModel)
    }
}
