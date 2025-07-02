//
//  MonitorNetworkConnectionService.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 20.03.2021.
//

import Network
import Combine

public protocol ReachabilityServiceProtocol: Sendable {
    @MainActor var isNetworkConnected: CurrentValueSubject<Bool, Never> { get }
}

public actor ReachabilityService: ReachabilityServiceProtocol {
    private let monitirQueue = DispatchQueue(label: "Monitor")
    private let monitor = NWPathMonitor()

    @MainActor
    public let isNetworkConnected = CurrentValueSubject<Bool, Never>(false)

    public init() {
        startMonitorNetworkConnection()
    }

    nonisolated private func startMonitorNetworkConnection() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }

            Task { [status = path.status] in
                let isConnected = status == .satisfied

                // Hop back to the actor to access its properties safely
                await self.updateConnectionStatus(isConnected)
            }
        }

        monitor.start(queue: monitirQueue)
    }
    
    private func updateConnectionStatus(_ isConnected: Bool) {
        Task { @MainActor in
            if isConnected != isNetworkConnected.value {
                isNetworkConnected.send(isConnected)
            }
        }
    }
}
