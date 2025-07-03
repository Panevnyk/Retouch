//
//  OrderDetailViewModel.swift
//  RetouchHome
//
//  Created by Panevnyk Vlad on 05.07.2021.
//

import RetouchDomain
import RetouchUtils
import RetouchNetworking
import RetouchDesignSystem
import Combine
import FactoryKit

@MainActor
public protocol OrderDetailViewModelProtocol {
    var title: String { get set }
    var description: String { get set }
    var price: String { get set }
    var isDownloadAndShareAvailable: Bool { get set }
    var isPayed: Bool { get set }
    var idRedoAvailable: Bool { get set }
    var rating: Int? { get set }
    var isNeedToShowRating: Bool { get set }

    var imageAfter: String { get set }
    var imageBefore: String { get set }

    func sendForRedo(redoDescription: String) async -> Bool
    func sendIsNotNewOrder() async -> Bool
    func removeOrder() async -> Bool
    func requestReview(force: Bool) async
}

public extension OrderDetailViewModelProtocol {
    func makeImageInfoContainerViewModel() -> ImageInfoContainerViewModelProtocol {
        return ImageInfoContainerViewModel(
            title: title,
            description: description,
            price: price,
            isDownloadAndShareAvailable: isDownloadAndShareAvailable,
            isPayed: isPayed,
            idRedoAvailable: idRedoAvailable,
            rating: rating)
    }
}

@MainActor
public class OrderDetailViewModel: OrderDetailViewModelProtocol {
    @Injected(\.notificationBanner) var notificationBanner
    
    private let ordersLoader: OrdersLoaderProtocol
    private let feedbackService: FeedbackServiceProtocol
    private let retouchGroupsLoader: RetouchGroupsLoaderProtocol
    private var order: Order {
        didSet { orderDidChange() }
    }
    
    private var retouchGroups: [RetouchGroup] = []

    public var title: String = ""
    public var description: String = ""
    public var price: String = ""
    public var isDownloadAndShareAvailable: Bool = false
    public var isPayed: Bool = false
    public var idRedoAvailable: Bool = false
    public var rating: Int? = nil
    public var isNeedToShowRating: Bool = false
    
    public var imageAfter: String = ""
    public var imageBefore: String = ""
    
    private var cancellable: [AnyCancellable] = []
    
    public init(ordersLoader: OrdersLoaderProtocol,
                retouchGroupsLoader: RetouchGroupsLoaderProtocol,
                feedbackService: FeedbackServiceProtocol,
                order: Order) {
        self.ordersLoader = ordersLoader
        self.retouchGroupsLoader = retouchGroupsLoader
        self.feedbackService = feedbackService
        self.order = order
        
        bindData()
        orderDidChange()
    }
}

// MARK: - Bind
extension OrderDetailViewModel {
    public func bindData() {
        retouchGroupsLoader.retouchGroupsPublisher
            .sink { retouchGroups in
                self.retouchGroups = retouchGroups
            }
            .store(in: &cancellable)
    }
}
// MARK: - Private
extension OrderDetailViewModel {
    private func orderDidChange() {
        let presentableValue = order
            .makePresentableTitleAndDescription(retouchGroups: retouchGroups)
        self.title = presentableValue.title
        self.description = presentableValue.description
        self.price = String(order.price)
        self.isDownloadAndShareAvailable = order.isPayed
        self.isPayed = order.isPayed
        self.idRedoAvailable = !order.isRedo
        self.rating = order.rating
        self.isNeedToShowRating = order.rating == nil && order.isNewOrder

        self.imageAfter = order.afterImage ?? ""
        self.imageBefore = order.beforeImage ?? ""
    }
    
    public func sendForRedo(redoDescription: String) async -> Bool {
        let parameters = RedoOrderParameters(id: order.id, redoDescription: redoDescription)
        do {
            let order = try await ordersLoader.redoOrder(parameters: parameters)
            self.order = order
            return true
        } catch {
            notificationBanner.showBanner(error)
            return false
        }
    }
    
    public func sendIsNotNewOrder() async -> Bool {
        let parameters = IsNewOrderParameters(id: order.id, isNewOrder: false)
        do {
            let order = try await ordersLoader.sendIsNewOrder(parameters: parameters)
            self.order = order
            return true
        } catch {
            notificationBanner.showBanner(error)
            return false
        }
    }
    
    public func removeOrder() async -> Bool {
        ActivityIndicatorHelper.shared.show()
        
        let parameters = RemoveOrderParameters(id: order.id)
        do {
            let value = try await ordersLoader.removeOrder(parameters: parameters)
            ActivityIndicatorHelper.shared.hide()
            return true
        } catch {
            notificationBanner.showBanner(error)
            return false
        }
    }
    
    public func requestReview(force: Bool) async {
        do {
            let newOrder = try await feedbackService.requestReview(for: order, force: force)
            self.order.rating = newOrder.rating
        } catch {
            notificationBanner.showBanner(error)
        }
    }
}

private extension Order {
    func makePresentableTitleAndDescription(retouchGroups: [RetouchGroup])
    -> (title: String, description: String) {
        var title = ""
        var description = ""

        selectedRetouchGroups.forEach { (selectedRetouchGroup) in
            if let retouchGroup = retouchGroups.first(
                where: { $0.id == selectedRetouchGroup.retouchGroupId }
            ) {
                if !title.isEmpty { title += ", " }
                title.append(retouchGroup.title)

                if !description.isEmpty { description += ", " }
                description.append(selectedRetouchGroup.descriptionForDesigner)
            }
        }

        return (title: title, description: description)
    }

}
