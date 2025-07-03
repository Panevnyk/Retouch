//
//  RetouchGroupsLoader.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 26.02.2021.
//

@preconcurrency import Combine
import RetouchDomain
import RetouchNetworking

public protocol RetouchGroupsLoaderProtocol: Sendable {
    @MainActor var retouchGroupsPublisher: CurrentValueSubject<[RetouchGroup], Never> { get }
    @MainActor var isLoadingPublisher: CurrentValueSubject<Bool, Never> { get }

    func loadRetouchGroups() async throws -> [RetouchGroup]
}

public actor RetouchGroupsLoader: RetouchGroupsLoaderProtocol {
    // MARK: - Properties
    // Boundaries
    private let restApiManager: RestApiManager

    // Data
    @MainActor
    public let retouchGroupsPublisher = CurrentValueSubject<[RetouchGroup], Never>([])
    @MainActor
    public let isLoadingPublisher = CurrentValueSubject<Bool, Never>(false)

    // MARK: - Inits
    public init(restApiManager: RestApiManager) {
        self.restApiManager = restApiManager
    }

    // MARK: - Load
    public func loadRetouchGroups() async throws -> [RetouchGroup] {
        await MainActor.run {
            isLoadingPublisher.send(true)
        }

        let method = RetouchGroupRestApiMethods.getList
        do {
            let retouchGroups: [RetouchGroup] = try await restApiManager.call(method: method)
            await MainActor.run {
                isLoadingPublisher.send(false)
                retouchGroupsPublisher.send(retouchGroups)
            }
            return retouchGroups
        } catch {
            await MainActor.run {
                isLoadingPublisher.send(false)
                retouchGroupsPublisher.send([])
            }
            throw error
        }
    }
}
