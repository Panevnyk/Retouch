//
//  ShareHelper.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 11.03.2021.
//

import UIKit

@MainActor
public final class ShareHelper: NSObject {
    @MainActor
    public static func share(_ urlString: String, from viewController: UIViewController) {
        guard let url = URL(string: urlString) else {
            AlertHelper.show(title: "Fail to share", message: nil)
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [url],
                                                              applicationActivities: nil)
        // 'UIPopoverPresentationController (<UIPopoverPresentationController: 0x7f800ce7a850>)
        // should have a non-nil sourceView or barButtonItem set before the presentation occurs.
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = viewController.view
            activityViewController.popoverPresentationController?.sourceRect =
                CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY,
                       width: 0, height: 0)
            activityViewController.popoverPresentationController?.permittedArrowDirections = .down
        }
        viewController.present(activityViewController, animated: true)
    }
}
