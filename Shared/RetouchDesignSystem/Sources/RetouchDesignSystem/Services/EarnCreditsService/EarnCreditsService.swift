import UIKit
import RetouchDomain
import RetouchUtils
import RetouchNetworking
import FactoryKit

public struct EarnCreditsModel: Sendable {
    public let type: EarnCreditsType
    public let isAvailable: Bool
}

public enum EarnCreditsType: CaseIterable, Sendable {
    case viewVideoAd
    case leaveRatingOnAppStore
    case leaveCommentByURLOnAppStore
    case followUsOnInstagram
    case followUsOnFacebook
}

public extension EarnCreditsType {
    var diamondPrice: Int {
        switch self {
        case .viewVideoAd: return 2
        case .leaveRatingOnAppStore: return 8
        case .leaveCommentByURLOnAppStore: return 8
        case .followUsOnInstagram: return 5
        case .followUsOnFacebook: return 5
        }
    }
    
    var description: String {
        switch self {
        case .viewVideoAd: return "View a video ad"
        case .leaveRatingOnAppStore: return "Leave a rating\non App Store"
        case .leaveCommentByURLOnAppStore: return "Leave a review\non App Store"
        case .followUsOnInstagram: return "Follow us on\nInstagram"
        case .followUsOnFacebook: return "Follow us on\nFacebook"
        }
    }
}

@MainActor
public protocol EarnCreditsServiceProtocol: Sendable {
    func getEarnCreditsModels() -> [EarnCreditsModel]
    func earnCredits(by earnCreditsType: EarnCreditsType) async
}

@MainActor
public class EarnCreditsService: EarnCreditsServiceProtocol {
    // MARK: - Properties
    @Injected(\.notificationBanner) private var notificationBanner
    @Injected(\.userDataService) private var userDataService
    
    private let storeKitService: StoreKitServiceProtocol
    private let reviewByURLService: ReviewByURLServiceProtocol
    private let rewardedAdsService: RewardedAdsServiceProtocol
    private let restApiManager: RestApiManager
    
    // MARK: - Inits
    public init(storeKitService: StoreKitServiceProtocol,
                reviewByURLService: ReviewByURLServiceProtocol,
                rewardedAdsService: RewardedAdsServiceProtocol,
                restApiManager: RestApiManager) {
        self.storeKitService = storeKitService
        self.reviewByURLService = reviewByURLService
        self.rewardedAdsService = rewardedAdsService
        self.restApiManager = restApiManager
    }
    
    // MARK: - Public
    public func getEarnCreditsModels() -> [EarnCreditsModel] {
        return [/*EarnCreditsModel(type: .viewVideoAd, isAvailable: true),*/
//                EarnCreditsModel(type: .leaveRatingOnAppStore, isAvailable: storeKitService.shouldRequestReview),
                EarnCreditsModel(type: .leaveCommentByURLOnAppStore, isAvailable: reviewByURLService.shouldRequestReview)/*,
                EarnCreditsModel(type: .followUsOnInstagram, isAvailable: true),
                EarnCreditsModel(type: .followUsOnFacebook, isAvailable: true)*/]
    }
    
    public func earnCredits(by earnCreditsType: EarnCreditsType) async {
        switch earnCreditsType {
        case .viewVideoAd:
            rewardedAdsService.loadRewardedAd()
        case .leaveRatingOnAppStore:
            storeKitService.requestReview()
            await refill(by: earnCreditsType, withDelay: true)
        case .leaveCommentByURLOnAppStore:
            reviewByURLService.requestReview()
            await refill(by: earnCreditsType, withDelay: true)
        case .followUsOnInstagram:
            break
        case .followUsOnFacebook:
            break
        }
    }
}

// MARK: - API
private extension EarnCreditsService {
    func refill(by earnCreditsType: EarnCreditsType, withDelay: Bool) async {
        await MainActor.run {
            ActivityIndicatorHelper.shared.show()
        }
        
        if withDelay {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
        }
        
        let refillAmount = earnCreditsType.diamondPrice
        let parameters = GemsParameters(refillAmount: String(refillAmount))
        let method = GemsRestApiMethods.refill(parameters)
        do {
            let _: String = try await restApiManager.call(method: method)
            await MainActor.run {
                ActivityIndicatorHelper.shared.hide()
                userDataService.update(gemCount: userDataService.user.gemCount + refillAmount)
                AlertHelper.show(title: "You successfully earned \(refillAmount) gems", message: nil)
            }
        } catch {
            await MainActor.run {
                ActivityIndicatorHelper.shared.hide()
                notificationBanner.showBanner(error)
            }
        }
    }
}
