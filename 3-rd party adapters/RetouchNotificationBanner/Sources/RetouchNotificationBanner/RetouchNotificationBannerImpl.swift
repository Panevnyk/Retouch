// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import RetouchUtils
import NotificationBannerSwift
import RetouchDesignSystem
import UIKit

@MainActor
public class RetouchNotificationBannerImpl: RetouchNotificationBanner {
    nonisolated public init() {}
    
    public func showErrorMessagge(_ text: String) {
        show(title: "", subtitle: text, style: .danger)
    }

    public func showBanner(_ error: Error) {
        showBanner(error: error, success: nil)
    }

    public func showBanner(error: Error?, success: String?) {
        var title = ""
        var subtitle = ""
        let style: RetouchBannerStyle

        if let error = error {
            title = "Error"
            subtitle = error.localizedDescription
            style = .danger
        } else {
            title = "Success"
            subtitle = success ?? ""
            style = .success
        }

        show(title: title, subtitle: subtitle, style: style)
    }
    
    public func show(title: String, style: RetouchBannerStyle) {
        show(title: title, subtitle: nil, style: style)
    }
    
    public func show(title: String, subtitle: String?, style: RetouchBannerStyle) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, leftView: nil, rightView: nil, style: style.bannerStyle, colors: CustomBannerColors())
        banner.duration = 1.5
        banner.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        banner.subtitleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        banner.subtitleLabel?.lineBreakMode = .byTruncatingMiddle
        banner.show()
    }
}

extension RetouchBannerStyle {
    var bannerStyle: BannerStyle {
        switch self {
        case .danger:
            return .danger
        case .info:
            return .info
        case .success:
            return .success
        case .warning:
            return .warning
        case .customView:
            return .customView
        }
    }
}

fileprivate class CustomBannerColors: BannerColorsProtocol {
    public func color(for style: BannerStyle) -> UIColor {
        switch style {
            case .danger:
                return .kRed
            case .info:
                return .kGrayText
            case .customView:
                return .clear
            case .success:
                return .kGreen
            case .warning:
                return .kRed
        }
    }
}
