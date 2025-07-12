//
//  PhotoGalleryViewModel.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 18.10.2022.
//

import UIKit
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem
import Combine
import FactoryKit

@MainActor
public protocol PhotoGalleryViewCoordinatorDelegate: BaseBalanceCoordinatorDelegate, BaseCoordinatorDelegate {
    func didSelectOrder(_ order: Order)
    func didSelectOrderNotEnoughGems(orderAmount: Int)
}

@MainActor
public class PhotoGalleryViewModel: ObservableObject {
    // MARK: - Properties
    @Injected(\.analytics) var analytics
    @Injected(\.notificationBanner) var notificationBanner
    @Injected(\.userDataService) private var userDataService
    
    // Boundaries
    let ordersLoader: OrdersLoaderProtocol
    let phImageLoader: PHImageLoaderProtocol
    var retouchGroups: [PresentableRetouchGroup] = []
    let iapService: IAPServiceProtocol
    let freeGemCreditCountService: FreeGemCreditCountServiceProtocol
    
    var productsResponse: [IAPProductResponse] = []
    
    var image: UIImage? {
        didSet { Task { scaledImage = image?.scalePreservingAspectRatio() } }
    }
    
    public var isEnoughGemsForOrder: Bool {
        userDataService.user.gemCount >= getOrderAmount()
    }
    
    public private(set) var ordersCount = 0
    public var isCountainOrderHistory: Bool {
        ordersCount > 0
    }
    
    // Delegate
    public weak var coordinatorDelegate: PhotoGalleryViewCoordinatorDelegate?
    
    // Combine
    @Published var scaledImage: UIImage?
    @Published var retouchCost: Int = Constants.minRetouchingCost
    @Published var isOrderAvailable: Bool = false
    @Published var isPurchaseBlurViewHidden: Bool = true
    
    @Published var openGroupIndex: Int?
    @Published var openTagIndex: Int?
    
    var animationValue = ""
    
    private var cancellable: [AnyCancellable] = []
    
    // MARK: - Init
    public init(ordersLoader: OrdersLoaderProtocol,
                phImageLoader: PHImageLoaderProtocol,
                retouchGroups: [RetouchGroup],
                iapService: IAPServiceProtocol,
                freeGemCreditCountService: FreeGemCreditCountServiceProtocol,
                image: UIImage?) {
        self.ordersLoader = ordersLoader
        self.phImageLoader = phImageLoader
        self.retouchGroups = retouchGroups
            .sorted(by: { $0.orderNumber < $1.orderNumber })
            .map { group in
                group.tags = group.tags.sorted(by: { $0.orderNumber < $1.orderNumber })
                return PresentableRetouchGroup(retouchGroup: group)
            }
        self.iapService = iapService
        self.freeGemCreditCountService = freeGemCreditCountService
        self.image = image
        
        bindData()
    }
}

// MARK: - Load Data
private extension PhotoGalleryViewModel {
    func bindData() {
        bindProperties()
        bindServices()
    }
    
    func bindProperties() {
        $openGroupIndex
            .sink { _ in
                self.openTagIndex = nil
            }
            .store(in: &cancellable)
        
        $openTagIndex
            .sink { _ in
                self.updateRetouchCost()
            }
            .store(in: &cancellable)
        
        $retouchCost
            .sink { value in
                self.isOrderAvailable = value != Constants.minRetouchingCost
            }
            .store(in: &cancellable)
        
        Publishers
            .CombineLatest($openGroupIndex, $openTagIndex)
            .sink {
                self.animationValue = String($0 ?? -1) + String($1 ?? -1)
            }
            .store(in: &cancellable)
    }
    
    func bindServices() {
        iapService.getProducts { [weak self] (response) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.productsResponse = response
            }
        }
        
        ordersLoader.ordersPublisher
            .sink { orders in
                self.ordersCount = orders.count
            }
            .store(in: &cancellable)
    }
}

// MARK: - Actions
extension PhotoGalleryViewModel {
    public func viewOnAppear() {

    }
    
    public func order() {
        didSelectFreeOrStandartOrder()
    }

    public func didSelectBalance() {
        coordinatorDelegate?.didSelectBalanceAction()
    }

    public func didSelectBack() {
        coordinatorDelegate?.didSelectBackAction()
    }
}

// MARK: - Public data
extension PhotoGalleryViewModel {
    public func getOrderAmount() -> Int {
        return retouchCost
    }

    public func getOrderPrice() -> String {
        return String(getOrderAmount())
    }
    
    public func getOrderPriceUSD() -> String? {
        guard let iapProductResponse = getMinIAPProductResponse(gemsCount: getOrderAmount()) else { return nil }
        return iapProductResponse.price.stringValue + " " + iapProductResponse.currencyCode
    }
    
    public func getUserFreeGemCreditCount() -> String {
        guard let freeGemCreditCount = userDataService.user.freeGemCreditCount else { return "" }
        return String(freeGemCreditCount)
    }
    
    public func getMinIAPProductResponse(gemsCount: Int) -> IAPProductResponse? {
        let products = productsResponse.sorted(by: { $0.gemsCount < $1.gemsCount })
        return products.first(where: { $0.gemsCount >= gemsCount })
    }
    
    public func isFirstOrderForFreeAvailabel() -> Bool {
        return (userDataService.user.freeGemCreditCount ?? 0) > 0
        && (userDataService.user.freeGemCreditCount ?? 0) == userDataService.user.gemCount
        && ordersLoader.ordersPublisher.value.count == 0
    }
    
    public func isFirstOrderForFreeOutOfFreeGemCount() -> Bool {
        return isFirstOrderForFreeAvailabel()
        && (userDataService.user.freeGemCreditCount ?? 0) < retouchCost
    }
}

extension PhotoGalleryViewModel {
    func updateRetouchCost() {
        var cost = Constants.minRetouchingCost
        retouchGroups.forEach { retouchGroup in
            retouchGroup.selectedRetouchTags.forEach { selectedTag in
                cost += selectedTag.price
            }
        }

        retouchCost = cost
    }
}
