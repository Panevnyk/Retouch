//
//  ForceUpdateAppVersionViewController.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 08.04.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

public final class ForceUpdateAppVersionViewController: UIViewController {
    @Injected(\.analytics) private var analytics
    
    private let placeholderView = PlaceholderViewUIKit()

    public override func viewDidLoad() {
        super.viewDidLoad()
        addPlaceholderview()
        analytics.logScreen(.forceUpdateAppVersion)
    }

    private func addPlaceholderview() {
        placeholderView.setTitle("New Retouch You version available")
        placeholderView.setSubtitle("Please, go to App Store and update Retouch You version")
        placeholderView.setActionButtonTitle("Go to App Store")
        placeholderView.setImage(
            UIImage(named: "icTimeToUpdate", in: Bundle.designSystem, compatibleWith: nil))
        placeholderView.delegate = self
        view.addSubviewUsingConstraints(view: placeholderView)
    }
}

// MARK: - PlaceholderViewDelegate
extension ForceUpdateAppVersionViewController: PlaceholderViewDelegate {
    public func didTapActionButton(from view: PlaceholderViewUIKit) {
        if let url = URL(string: Constants.retouchYouAppStoreLink) {
            UIApplication.shared.open(url)
            analytics.logAction(.forceUpdateAppVersion)
        }
    }
}
