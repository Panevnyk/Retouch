// The Swift Programming Language
// https://docs.swift.org/swift-book

import RetouchUtils
import Firebase
import FirebaseAnalytics

public class RetouchAnalyticsService: AnalyticsService {
    public init() {}
    
    public func setupUserID() {
        #if DEBUG
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        #endif
        Task { @MainActor in
            Analytics.setUserID(DeviceIdService.deviceId)
        }
    }
    
    public func logScreen(_ screen: Constants.Analytics.EventScreen) {
        logEvent(name: screen.rawValue)
    }
    
    public func logAction(_ action: Constants.Analytics.EventAction) {
        logEvent(name: action.rawValue)
    }
    
    private func logEvent(name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
