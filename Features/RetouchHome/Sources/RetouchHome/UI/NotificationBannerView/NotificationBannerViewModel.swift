//
//  NotificationBannerViewModel.swift
//  RetouchHome
//
//  Created by Panevnyk Vlad on 28.01.2022.
//

import UIKit

final public class NotificationBannerViewModel {
    public var notificationTitle: String
    public var notificationDescription: String?
    public var attributedNotificationDescription: NSAttributedString?
    public var indicatorImage: UIImage?
    public var closeAction: (() -> Void)?
    
    public var attrNotificationDescription: AttributedString? {
        if let attributedNotificationDescription = attributedNotificationDescription {
            return AttributedString(attributedNotificationDescription)
        }
        return nil
    }
    
    public init(notificationTitle: String,
                notificationDescription: String?,
                indicatorImage: UIImage?,
                closeAction: (() -> Void)?) {
        self.notificationTitle = notificationTitle
        self.notificationDescription = notificationDescription
        self.indicatorImage = indicatorImage
        self.closeAction = closeAction
    }
    
    public init(notificationTitle: String,
                attributedNotificationDescription: NSAttributedString?,
                indicatorImage: UIImage?,
                closeAction: (() -> Void)?) {
        self.notificationTitle = notificationTitle
        self.attributedNotificationDescription = attributedNotificationDescription
        self.indicatorImage = indicatorImage
        self.closeAction = closeAction
    }
}
