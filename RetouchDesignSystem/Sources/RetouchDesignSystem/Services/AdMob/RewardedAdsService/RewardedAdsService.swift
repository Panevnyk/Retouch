//
//  RewardedAdsService.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 11.07.2022.
//

//import GoogleMobileAds
import UIKit

public protocol RewardedAdsServiceProtocol {
    func loadRewardedAd()
}

public class RewardedAdsService: NSObject, RewardedAdsServiceProtocol {
    // MARK: - Properties
//    private var rewardedAd: GADRewardedAd?
    
    // MARK: - Inits
    public override init() {
        super.init()
    }
    
    // MARK: - Public
    public func loadRewardedAd() {
//        let request = GADRequest()
//        GADRewardedAd.load(withAdUnitID: Constants.rewardedAdsUnitId,
//                           request: request,
//                           completionHandler: { [self] ad, error in
//            if let error = error {
//                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
//                return
//            }
//            rewardedAd = ad
//            print("Rewarded ad loaded.")
//            rewardedAd?.fullScreenContentDelegate = self
//
//            self.presentRewardedVideo()
//        })
    }
    
//    func presentRewardedVideo() {
//        if let ad = rewardedAd, let presentationViewController = UIApplication.presentationViewController {
//            ad.present(fromRootViewController: presentationViewController) {
//                let reward = ad.adReward
//                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
//                // TODO: Reward the user.
//            }
//        } else {
//            print("Ad wasn't ready")
//        }
//    }
}

//// MARK: - GADFullScreenContentDelegate
//extension RewardedAdsService: GADFullScreenContentDelegate {
//    /// Tells the delegate that the ad failed to present full screen content.
//    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        print("Ad did fail to present full screen content.")
//    }
//
//    /// Tells the delegate that the ad will present full screen content.
//    public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("Ad will present full screen content.")
//    }
//
//    /// Tells the delegate that the ad dismissed full screen content.
//    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("Ad did dismiss full screen content.")
//    }
//}
//
