//
//  ReviewByURLService.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 20.08.2022.
//

import UIKit
import RetouchDomain
import RetouchUtils

public protocol ReviewByURLServiceProtocol {
    @MainActor var shouldRequestReview: Bool { get }
    @MainActor func requestReview()
}

@MainActor
public class ReviewByURLService: ReviewByURLServiceProtocol {
    private static let isReviewRequested = "ReviewByURLServiceIsReviewRequested"
    
    @KeychainBacked(key: ReviewByURLService.isReviewRequested)
    var isReviewRequested = "false"
    
    public init() {}
    
    public var shouldRequestReview: Bool {
        return isReviewRequested == "false"
    }
    
    public func requestReview() {
        let urlStr = Constants.retouchYouWriteReviewAppStoreLink
        guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        isReviewRequested = "true"
    }
}
