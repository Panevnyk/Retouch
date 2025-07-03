//
//  FeedbackService.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 05.07.2021.
//

import Foundation
import RetouchDomain

@MainActor
public protocol FeedbackServiceProtocol: Sendable {
    func requestReview(for order: Order, force: Bool) async throws -> Order
}

@MainActor
public class FeedbackService: FeedbackServiceProtocol {
    // MARK: - Properties
    private let storeKitService: StoreKitServiceProtocol
//    private let localFeedbackService: LocalFeedbackServiceProtocol
//    private let remoteConfigService: RemoteConfigServiceProtocol
    
    // MARK: - Inits
    public init(storeKitService: StoreKitServiceProtocol,
//                localFeedbackService: LocalFeedbackServiceProtocol,
                /*remoteConfigService: RemoteConfigServiceProtocol*/) {
        self.storeKitService = storeKitService
//        self.localFeedbackService = localFeedbackService
//        self.remoteConfigService = remoteConfigService
    }
    
    // MARK: - Request review
    public func requestReview(for order: Order, force: Bool) async throws -> Order {
        if isAppStoreReviewAvailable {
            requestAppStoreReview()
            throw NSError.init(domain: "Request local review error", code: 404)
        } else if force || isLocalReviewAvailable(for: order) {
            try await requestLocalReview(for: order)
        } else {
            throw NSError.init(domain: "Request local review error", code: 404)
        }
    }
    
    // MARK: - AppStore review
    private var isAppStoreReviewAvailable: Bool {
        /*remoteConfigService.isAppStoreFeedbackEnabled && */storeKitService.shouldRequestReview
    }
    
    private func requestAppStoreReview() {
        storeKitService.requestReview()
    }
    
    // MARK: - Local review
    private func isLocalReviewAvailable(for order: Order) -> Bool {
        /*remoteConfigService.isLocalFeedbackEnabled && */order.rating == nil
    }
    
    private func requestLocalReview(for order: Order) async throws -> Order {
        throw NSError.init(domain: "Request local review error", code: 404)
//        localFeedbackService.requestLocalReview(for: order, completion: completion)
    }
}
