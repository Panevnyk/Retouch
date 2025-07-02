//
//  SilentOrdersLoader.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 20.08.2022.
//

@preconcurrency import Combine
import Foundation
import RetouchDomain

public protocol SilentOrdersLoaderProtocol: Sendable {
    func startListenersIfNeeded() async
}

public actor SilentOrdersLoader: SilentOrdersLoaderProtocol {
    // MARK: - Properties
    private let ordersLoader: OrdersLoaderProtocol
    private let currentUserLoader: CurrentUserLoaderProtocol
    
    private var refreshTimer: Timer?
    
    private var isListenersStarted = false
    
    private var cancellable: [AnyCancellable] = []

    // MARK: - Inits
    public init(ordersLoader: OrdersLoaderProtocol,
                currentUserLoader: CurrentUserLoaderProtocol) {
        self.ordersLoader = ordersLoader
        self.currentUserLoader = currentUserLoader
    }

    // MARK: - Public methods
    public func startListenersIfNeeded() async {
        guard !isListenersStarted else { return }
        isListenersStarted = true
        
        await ordersLoader.ordersPublisher
            .sink { (orders) in
                self.startTimerIfNeeded(orders: orders)
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Private methods
    private func startTimerIfNeeded(orders: [Order]) {
        if isNeedToStartListeners(orders: orders) {
            startTimer()
        }
    }
    
    private func startTimer() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 15 * 60, repeats: false, block: { timer in
            Task {
                await self.runTimedCode()
            }
        })
        RunLoop.current.add(refreshTimer!, forMode: .common)
    }

    private func invalidateTimer() {
        refreshTimer?.invalidate()
    }
    
    private func runTimedCode() async {
        let user = try? await currentUserLoader.autoSigninUser()
        
        if user != nil {
            _ = try? await ordersLoader.loadOrders()
        }
    }
    
    private func isNeedToStartListeners(orders: [Order]) -> Bool {
        return orders.contains(where: { $0.status != .completed && $0.status != .canceled })
    }
}
