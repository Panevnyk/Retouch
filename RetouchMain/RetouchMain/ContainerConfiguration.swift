//
//  ContainerConfiguration.swift
//  RetouchMain
//
//  Created by Vladyslav Panevnyk  on 04.06.2025.
//

import RetouchUtils
import RetouchAnalytics
import RetouchNotificationBanner
import RetouchImageLoader
import FactoryKit

extension Container {
    static func configure() {
        Container.shared.analytics.register {
            RetouchAnalyticsService()
        }
        
        Container.shared.notificationBanner.register {
            RetouchNotificationBannerImpl()
        }
        
        Container.shared.imageLoader.register {
            RetouchImageLoaderImp()
        }
    }
}
