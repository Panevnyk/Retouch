//
//  OrdersLoader.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 14.02.2021.
//

import UIKit
@preconcurrency import Combine
import RetouchDomain
import RetouchNetworking

public struct CreateOrderModel: Sendable {
    public let beforeImage: UIImage
    public let selectedRetouchGroups: [SelectedRetouchGroupParameters]
    public let price: Int
    public let isFreeOrder: Bool

    public init(beforeImage: UIImage,
                selectedRetouchGroups: [SelectedRetouchGroupParameters],
                price: Int,
                isFreeOrder: Bool) {
        self.beforeImage = beforeImage
        self.selectedRetouchGroups = selectedRetouchGroups
        self.price = price
        self.isFreeOrder = isFreeOrder
    }
}

public protocol OrdersLoaderProtocol: Sendable {
    @MainActor var ordersPublisher: CurrentValueSubject<[Order], Never> { get }
    @MainActor var isLoadingPublisher: CurrentValueSubject<Bool, Never> { get }

    func loadOrders() async throws -> [Order]
    func redoOrder(parameters: RedoOrderParameters) async throws -> Order
    func createOrder(createOrderModel: CreateOrderModel) async throws -> Order
    func removeOrder(parameters: RemoveOrderParameters) async throws -> String
    func sendRating(orderRatingParameters: OrderRatingParameters) async throws -> Order
    func sendIsNewOrder(parameters: IsNewOrderParameters) async throws -> Order
    func didChangeStatus(by model: OrderStatusChangedNotificationModel) async
}

public actor OrdersLoader: OrdersLoaderProtocol {
    // MARK: - Properties
    // Boundaries
    private let restApiManager: RestApiManager

    // Data
    @MainActor
    public var ordersPublisher = CurrentValueSubject<[Order], Never>([])
    @MainActor
    public let isLoadingPublisher = CurrentValueSubject<Bool, Never>(false)

    // MARK: - Inits
    public init(restApiManager: RestApiManager) {
        self.restApiManager = restApiManager
    }

    // MARK: - Load
    public func loadOrders() async throws -> [Order] {
        await MainActor.run {
            isLoadingPublisher.send(true)
        }

        let method = OrderRestApiMethods.getList
        do {
            let orders: [Order] = try await restApiManager.call(method: method)
            await MainActor.run {
                self.isLoadingPublisher.send(false)
                self.ordersPublisher.send(orders)
            }
            return orders
        } catch {
            await MainActor.run {
                self.isLoadingPublisher.send(false)
                self.ordersPublisher.send([])
            }
            throw error
        }
    }

    public func redoOrder(parameters: RedoOrderParameters) async throws -> Order {
        await MainActor.run {
            isLoadingPublisher.send(true)
        }
        
        let method = OrderRestApiMethods.redoOrder(parameters)
        do {
            let order: Order = try await restApiManager.call(method: method)
            await MainActor.run {
                self.isLoadingPublisher.send(false)
                
                var orders = self.ordersPublisher.value
                if let index = orders.firstIndex(where: { $0.id == order.id }) {
                    orders[index] = order
                    self.ordersPublisher.send(orders)
                }
            }
            return order
        } catch {
            await MainActor.run {
                self.isLoadingPublisher.send(false)
            }
            throw error
        }
    }

    public func createOrder(createOrderModel: CreateOrderModel) async throws -> Order {
        await MainActor.run {
            isLoadingPublisher.send(true)
        }
        
        do {
            let beforeImage: BeforeImage = try await uploadBeforeImage(beforeImage: createOrderModel.beforeImage)

                let parameters = CreateOrderParameters(beforeImage: beforeImage.image,
                                                       selectedRetouchGroups: createOrderModel.selectedRetouchGroups,
                                                       price: createOrderModel.price,
                                                       isFreeOrder: createOrderModel.isFreeOrder)
                let method = OrderRestApiMethods.create(parameters)
                let newOrder: Order = try await restApiManager.call(method: method)
                await MainActor.run {
                    self.isLoadingPublisher.send(false)
                    
                    UserData.shared.user.gemCount = UserData.shared.user.gemCount - newOrder.price
                    var orders = self.ordersPublisher.value
                    orders.insert(newOrder, at: 0)
                    self.ordersPublisher.send(orders)
                }
                return newOrder
        } catch {
            await MainActor.run {
                self.isLoadingPublisher.send(false)
            }
            throw error
        }
    }
    
    public func removeOrder(parameters: RemoveOrderParameters) async throws -> String {
        await MainActor.run {
            isLoadingPublisher.send(true)
        }

        let method = OrderRestApiMethods.removeOrder(parameters)
        do {
            let value: String = try await restApiManager.call(method: method)
            await MainActor.run {
                self.isLoadingPublisher.send(false)
                
                var orders = self.ordersPublisher.value
                orders.removeAll(where: { $0.id == parameters.id })
                self.ordersPublisher.send(orders)
            }
            return value
        } catch {
            await MainActor.run {
                self.isLoadingPublisher.send(false)
            }
            throw error
        }
    }
    
    public func sendRating(orderRatingParameters: OrderRatingParameters) async throws -> Order {
        await MainActor.run {
            isLoadingPublisher.send(true)
        }
        
        let method = OrderRestApiMethods.sendRating(orderRatingParameters)
        do {
            let order: Order = try await restApiManager.call(method: method)
            await MainActor.run {
                self.isLoadingPublisher.send(false)
                
                var orders = self.ordersPublisher.value
                if let index = orders.firstIndex(where: { $0.id == order.id }) {
                    orders[index] = order
                    self.ordersPublisher.send(orders)
                }
            }
            return order
        } catch {
            await MainActor.run {
                self.isLoadingPublisher.send(false)
            }
            throw error
        }
    }
    
    public func sendIsNewOrder(parameters: IsNewOrderParameters) async throws -> Order {
        await MainActor.run {
            isLoadingPublisher.send(true)
        }
        
        let method = OrderRestApiMethods.isNewOrder(parameters)
        do {
            let order: Order = try await restApiManager.call(method: method)
            await MainActor.run {
                self.isLoadingPublisher.send(false)
                
                var orders = self.ordersPublisher.value
                if let index = orders.firstIndex(where: { $0.id == order.id }) {
                    orders[index] = order
                    self.ordersPublisher.send(orders)
                }
            }
            return order
        } catch {
            await MainActor.run {
                self.isLoadingPublisher.send(false)
            }
            throw error
        }
    }
    
    public func didChangeStatus(by model: OrderStatusChangedNotificationModel) async {
        await MainActor.run {
            let orders = self.ordersPublisher.value

            if let index = orders.firstIndex(where: { $0.id == model.orderId }) {
                orders[index].status = model.orderStatus
                orders[index].statusDescription = model.orderStatusDescription
                self.ordersPublisher.send(orders)
            }
            
            if let userGemCount = model.userGemCount {
                UserData.shared.user.gemCount = userGemCount
            }
        }
    }

    private func uploadBeforeImage(beforeImage: UIImage) async throws -> BeforeImage {
        guard let pngBeforeImage = beforeImage.pngData() else {
            fatalError("!!! Fail to create png before image from UIImage opbject!!!")
        }

        let multipartObject = MultipartObject(
            key: "beforeImage",
            data: pngBeforeImage,
            mimeType: "image/png",
            filename: generateImageName()
        )
        let multipartData = CreateOrderMultipartData(multipartObjects: [multipartObject])
        let method = OrderRestApiMethods.uploadBeforeImage

        let object: BeforeImage = try await restApiManager.call(multipartData: multipartData, method: method)
        return object
    }

    private func generateImageName() -> String {
        let name = String(Int(Date().timeIntervalSince1970MiliSec))
        return name + ".png"
    }
}
