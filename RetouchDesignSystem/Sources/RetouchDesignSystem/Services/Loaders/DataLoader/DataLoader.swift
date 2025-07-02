//
//  DataLoader.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 20.03.2021.
//

import Foundation
import RetouchDomain

public protocol DataLoaderProtocol: AnyObject, Sendable {
    func loadData() async throws
}

public actor DataLoader: DataLoaderProtocol {
    // MARK: - Properties
    private let ordersLoader: OrdersLoaderProtocol
    private let silentOrdersLoader: SilentOrdersLoaderProtocol
    private let retouchGroupsLoader: RetouchGroupsLoaderProtocol
    private let currentUserLoader: CurrentUserLoaderProtocol

    // MARK: - Inits
    public init(ordersLoader: OrdersLoaderProtocol,
                silentOrdersLoader: SilentOrdersLoaderProtocol,
                retouchGroupsLoader: RetouchGroupsLoaderProtocol,
                currentUserLoader: CurrentUserLoaderProtocol) {
        self.ordersLoader = ordersLoader
        self.silentOrdersLoader = silentOrdersLoader
        self.retouchGroupsLoader = retouchGroupsLoader
        self.currentUserLoader = currentUserLoader
    }

    // MARK: - Public methods
    public func loadData() async throws {
#if DEBUG
        print("Load data will autoSigninUser")
#endif
        let _: User = try await currentUserLoader.autoSigninUser()
        
#if DEBUG
        print("Load data will loadRetouchGroups")
#endif
        let _: [RetouchGroup] = try await retouchGroupsLoader.loadRetouchGroups()

#if DEBUG
        print("Load data will loadOrders")
#endif
        let _: [Order] = try await ordersLoader.loadOrders()
        await silentOrdersLoader.startListenersIfNeeded()
    }
}
