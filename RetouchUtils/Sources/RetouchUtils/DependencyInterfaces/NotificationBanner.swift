//
//  RetouchNotificationBanner.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 12.11.2020.
//

import Foundation

@MainActor
public protocol RetouchNotificationBanner: Sendable {
    func showErrorMessagge(_ text: String)
    func showBanner(_ error: Error)
    func showBanner(error: Error?, success: String?)
    func show(title: String, style: RetouchBannerStyle)
    func show(title: String, subtitle: String?, style: RetouchBannerStyle)
}

public enum RetouchBannerStyle: Sendable {
    case danger
    case info
    case customView
    case success
    case warning
}
