//
//  RemoteConfigService.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 08.04.2021.
//

import UIKit
//import Firebase

public protocol RemoteConfigServiceProtocol {
    var minimumAppVersion: Int { get }
    var isForceAppUpdatingNeeded: Bool { get }
    var isAppStoreFeedbackEnabled: Bool { get }
    var isLocalFeedbackEnabled: Bool { get }
    
    func setup()
}

//public final class RemoteConfigService: RemoteConfigServiceProtocol {
//    // MARK: - Properties
//    // Dependencies
//    private let remoteConfig: RemoteConfig
//    
//    // Public
//    public var minimumAppVersion: Int {
//        remoteConfig[RestApiConstants.minimumAppVersion].numberValue.intValue
//    }
//    
//    public var isForceAppUpdatingNeeded: Bool {
//        minimumAppVersion > Constants.remoteControlAppVersion
//    }
//    
//    public var isAppStoreFeedbackEnabled: Bool {
//        remoteConfig[RestApiConstants.isAppStoreFeedbackEnabled].numberValue.intValue == 1
//    }
//    
//    public var isLocalFeedbackEnabled: Bool {
//        remoteConfig[RestApiConstants.isLocalFeedbackEnabled].numberValue.intValue == 1
//    }
//    
//    // Helpers
//    private var fetchAndActivateResult: Bool? {
//        didSet {
//            if let fetchAndActivateResult = fetchAndActivateResult {
//                fetchAndActivateResultCompletion?(fetchAndActivateResult)
//            }
//        }
//    }
//    private var fetchAndActivateResultCompletion: ((_ succeeded: Bool) -> Void)? {
//        didSet {
//            if let fetchAndActivateResult = fetchAndActivateResult {
//                fetchAndActivateResultCompletion?(fetchAndActivateResult)
//            }
//        }
//    }
//
//    // MARK: - Init
//    public init() {
//        remoteConfig = RemoteConfig.remoteConfig()
//    }
//    
//    // MARK: - Public methods
//    public func setup() {
//        let defaults = [RestApiConstants.minimumAppVersion: 1 as NSObject,
//                        RestApiConstants.isAppStoreFeedbackEnabled: 1 as NSObject,
//                        RestApiConstants.isLocalFeedbackEnabled: 1 as NSObject]
//        remoteConfig.setDefaults(defaults)
//        
//#if DEBUG
//        print("Firebase Remote Config will fetchAndActivate")
//#endif
//        remoteConfig.fetchAndActivate { status, error in
//            guard error == nil else {
//#if DEBUG
//                print("Firebase Remote Config error: \(String(describing: error))")
//#endif
//                self.fetchAndActivateResult = false
//                return
//            }
//            
//            switch status {
//            case .successFetchedFromRemote, .successUsingPreFetchedData:
//#if DEBUG
//                print("Hooray! Firebase Remote Config synced. Go on")
//#endif
//                self.fetchAndActivateResult = true
//                self.updateUIIfNeeded()
//                
//            default:
//                self.fetchAndActivateResult = false
//            }
//        }
//    }
//    
//    private func updateUIIfNeeded() {
//        if isForceAppUpdatingNeeded {
//            NotificationCenterHelper.ForceAppUpdate.send()
//        }
//    }
//}
