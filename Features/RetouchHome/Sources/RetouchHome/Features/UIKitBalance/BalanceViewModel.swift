//
//  BalanceViewModel.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 17.02.2021.
//

import UIKit
import Combine
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

public enum GetCreditsType {
    case buy
    case earn
}

public enum BalanceSectionType {
    case subscription
    case oneTime
    case getForFree
}

extension BalanceSectionType {
    var title: String {
        switch self {
        case .subscription: return "Subscriptions"
        case .oneTime: return "One-time purchase"
        case .getForFree: return "Get gems for free"
        }
    }
}

@MainActor
public protocol BalanceViewModelDelegate: AnyObject {
    func reloadData()
    func purchasedSuccessfully()
}

@MainActor
public protocol BalanceViewModelProtocol {
    var delegate: BalanceViewModelDelegate? { get set }

    func setGetCreditsType(index: Int)
    func getTitle() -> String
    
    var numberOfSections: Int { get }
    func getSectionTitle(by section: Int) -> String
    func balanceSectionType(by section: Int) -> BalanceSectionType
    func itemsCount(in section: Int) -> Int
    func oneTimeViewModel(for item: Int) -> BalanceItemViewModelProtocol
    func earnViewModel(for item: Int) -> EarnBalanceItemViewModelProtocol
    
    func didSelectItem(for item: Int, section: Int, from viewController: UIViewController)
    func getAnalytics(for item: Int, section: Int) -> Constants.Analytics.EventAction
    
    func getOrderAmount() -> String?
    func getBalance() -> String
    func isEnoughCreditsForOrder() -> Bool
}

@MainActor
public final class BalanceViewModel: BalanceViewModelProtocol {
    // MARK: - Properties
    @Injected(\.userDataService) private var userDataService
    
    // Boundaries
    private var iapService: IAPServiceProtocol
    private let earnCreditsService: EarnCreditsServiceProtocol
    private let orderAmount: Int?
    
    private var getCreditsType: GetCreditsType = .buy

    // Data
    private var productsResponse: [IAPProductResponse] = [] {
        didSet {
            oneTimeItemViewModels = productsResponse
                .map { BalanceItemViewModel(productResponse: $0) }
        }
    }
    private var subscriptionsItemViewModels: [BalanceItemViewModelProtocol] = []
    private var oneTimeItemViewModels: [BalanceItemViewModelProtocol] = [] {
        didSet { delegate?.reloadData() }
    }
    private var earnItemViewModels: [EarnBalanceItemViewModelProtocol] = [] {
        didSet { delegate?.reloadData() }
    }
    private var cancellable: [AnyCancellable] = []

    // Delegates
    public weak var delegate: BalanceViewModelDelegate?

    // MARK: - Inits
    public init(iapService: IAPServiceProtocol,
                earnCreditsService: EarnCreditsServiceProtocol,
                orderAmount: Int?) {
        self.iapService = iapService
        self.earnCreditsService = earnCreditsService
        self.orderAmount = orderAmount
        
        updateData()
        bindData()
    }
}

// MARK: - Public methods
private extension BalanceViewModel {
    var currentBalanceSectionTypes: [BalanceSectionType] {
        switch getCreditsType {
        case .buy:
            var creditsType: [BalanceSectionType] = []
            if subscriptionsItemViewModels.count > 0 {
                creditsType.append(.subscription)
            }
            if oneTimeItemViewModels.count > 0 {
                creditsType.append(.oneTime)
            }
            return creditsType
        case .earn: return [.getForFree]
        }
    }
}

// MARK: - Public methods
extension BalanceViewModel {
    public func setGetCreditsType(index: Int) {
        getCreditsType = index == 0 ? .buy : .earn
    }
    
    public func getTitle() -> String {
        return orderAmount == nil ? "Get more Gems" : "You have insuffisial credits"
    }
    
    public var numberOfSections: Int {
        return currentBalanceSectionTypes.count
    }
    
    public func getSectionTitle(by section: Int) -> String {
        return currentBalanceSectionTypes[section].title
    }
    
    public func balanceSectionType(by section: Int) -> BalanceSectionType {
        return currentBalanceSectionTypes[section]
    }

    public func itemsCount(in section: Int) -> Int {
        let balanceSectionType = currentBalanceSectionTypes[section]
        switch balanceSectionType {
        case .subscription: return subscriptionsItemViewModels.count
        case .oneTime: return oneTimeItemViewModels.count
        case .getForFree: return earnItemViewModels.count
        }
    }

    public func oneTimeViewModel(for item: Int) -> BalanceItemViewModelProtocol {
        return oneTimeItemViewModels[item]
    }
    
    public func earnViewModel(for item: Int) -> EarnBalanceItemViewModelProtocol {
        return earnItemViewModels[item]
    }

    public func didSelectItem(for item: Int, section: Int, from viewController: UIViewController) {
        let balanceSectionType = currentBalanceSectionTypes[section]
        switch balanceSectionType {
        case .subscription:
            break
        case .oneTime:
            makeOneTimePurchase(for: item, from: viewController)
        case .getForFree:
            makeEarnCredits(for: item)
        }
    }
    
    private func makeOneTimePurchase(for item: Int, from viewController: UIViewController) {
        let productResponse = productsResponse[item]
        iapService.purchase(productResponse: productResponse) { isSuccessfully in
            if isSuccessfully {
                self.delegate?.purchasedSuccessfully()
            }
        }
    }
    
    private func makeEarnCredits(for item: Int) {
        Task {
            await earnCreditsService.earnCredits(by: earnItemViewModels[item].earnCreditsType)
            updateData()
        }
    }
    
    public func getAnalytics(for item: Int, section: Int) -> Constants.Analytics.EventAction {
        let balanceSectionType = currentBalanceSectionTypes[section]
        switch balanceSectionType {
        case .subscription:
            let productResponse = productsResponse[item]
            return productResponse.iapProduct.analytics
        case .oneTime:
            let productResponse = productsResponse[item]
            return productResponse.iapProduct.analytics
        case .getForFree:
            let earnItemViewModel = earnItemViewModels[item]
            return earnItemViewModel.earnCreditsType.analytics
        }
    }

    public func getOrderAmount() -> String? {
        guard let orderAmount = orderAmount else { return nil }
        return String(orderAmount)
    }

    public func getBalance() -> String {
        return String(userDataService.user.gemCount)
    }

    public func isEnoughCreditsForOrder() -> Bool {
        guard let orderAmount = orderAmount else { return false }
        return userDataService.user.gemCount >= orderAmount
    }
}

// MARK: - Data
private extension BalanceViewModel {
    func bindData() {
        iapService.getProducts { [weak self] (response) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.productsResponse = response
            }
        }
    }
    
    func updateData() {
        self.earnItemViewModels = makeEarnItems()
    }
}

// MARK: - Factories
private extension BalanceViewModel {
    func makeEarnItems() -> [EarnBalanceItemViewModelProtocol] {
        return earnCreditsService.getEarnCreditsModels().map {
            EarnBalanceItemViewModel(diamondPrice: String($0.type.diamondPrice),
                                     descriptionTitle: $0.type.description,
                                     earnCreditsType: $0.type,
                                     isAvailable: $0.isAvailable)
        }
    }
}

// MARK: - ApplePayServiceDelegate
extension IAPProduct {
    public var analytics: Constants.Analytics.EventAction {
        switch self {
        case .gems30: return .gems30
        case .gems50: return .gems50
        case .gems110: return .gems110
        case .gems180: return .gems180
        case .gems240: return .gems240
        case .gems300: return .gems300
        case .gems500: return .gems500
        case .gems1000: return .gems1000
        }
    }
}

// MARK: - Earn Analytics
extension EarnCreditsType {
    var analytics: Constants.Analytics.EventAction {
        switch self {
        case .viewVideoAd: return .earnGemsViewAVideoAd
        case .leaveRatingOnAppStore: return .earnGemsLeaveARatingOnAppStore
        case .leaveCommentByURLOnAppStore: return .earnGemsLeaveAReviewByURLOnAppStore
        case .followUsOnInstagram: return .earnGemsFollowUsOnInstagram
        case .followUsOnFacebook: return .earnGemsFollowUsOnFacebook
        }
    }
}
