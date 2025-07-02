//
//  StoreKitService.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 05.07.2021.
//

import StoreKit
import RetouchDomain
import RetouchUtils

@MainActor
public protocol StoreKitServiceProtocol {
    var shouldRequestReview: Bool { get }
    func requestReview()
}

@MainActor
public class StoreKitService: StoreKitServiceProtocol {
    private static let lastVersion = "StoreKitServiceLastVersion"
    private static let lastRequestDate = "StoreKitServiceLastRequestDate"
    
    private let app = UIApplication.shared
    private let mainBundle = Bundle.main
    
    @KeychainBacked(key: StoreKitService.lastVersion)
    var lastVersionPromptedForReview = ""
    
    @KeychainBacked(key: StoreKitService.lastRequestDate)
    var lastRequestString: String? = nil
    
    var lastRequest: Date? {
        get {
            if let lastRequestString = lastRequestString {
                return DateHelper.shared.fullDateStyleFormatter.date(from: lastRequestString)
            } else {
                return nil
            }
        }
        set {
            if let value = newValue {
                lastRequestString = DateHelper.shared.fullDateStyleFormatter.string(from: value)
            } else {
                lastRequestString = nil
            }
        }
    }
    
    var currentVersion: String {
        mainBundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    public init() {}
    
    public func requestReview() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
        
        lastVersionPromptedForReview = currentVersion
        lastRequest = Date()
    }
    
    public var shouldRequestReview: Bool {
        guard let lastRequest = lastRequest else { return true }
        return lastRequest < Date.oneWeekAgo && currentVersion != lastVersionPromptedForReview
    }
}
