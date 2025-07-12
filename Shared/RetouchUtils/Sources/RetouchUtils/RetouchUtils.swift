import FactoryKit

public extension Container {
    var analytics: Factory<AnalyticsService> {
        self { fatalError("Unregistered AnalyticsService dependency") }
    }

    var notificationBanner: Factory<RetouchNotificationBanner> {
        self { fatalError("Unregistered RetouchNotificationBanner dependency") }
    }
    
    var imageLoader: Factory<RetouchImageLoader> {
        self { fatalError("Unregistered RetouchImageLoader dependency") }
    }
    
    var userDataService: Factory<UserDataService> {
        self { fatalError("Unregistered UserDataService dependency") }
    }
}
