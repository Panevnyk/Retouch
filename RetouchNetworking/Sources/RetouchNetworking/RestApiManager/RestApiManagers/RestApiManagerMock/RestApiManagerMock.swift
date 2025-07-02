//
//  RestApiManagerMock.swift
//  RetouchNetworking
//
//  Created by Vladyslav Panevnyk  on 24.06.2025.
//

import Foundation

public final class RestApiManagerMock: RestApiManager {
    /// Init
    public init() {}
    
    /// URLSessionRAMDIContainer
    public let container: RestApiManagerDIContainer = URLSessionRAMDIContainer()
    
    // ---------------------------------------------------------------------
    // MARK: - Simple requests
    // ---------------------------------------------------------------------
    
    /// Object call
    ///
    /// - Parameters:
    ///   - method: RestApiMethod
    /// - Returns: T
    public func call<T: Decodable>(method: RestApiMethod) async throws -> T {
        throw NSError(domain: "RestApiManagerMock", code: 0, userInfo: nil)
    }
    
    /// Array call
    ///
    /// - Parameters:
    ///   - method: RestApiMethod
    /// - Returns: [T]
    public func callArray<T: Decodable>(method: RestApiMethod) async throws -> [T] {
        throw NSError(domain: "RestApiManagerMock", code: 0, userInfo: nil)
    }
    
    /// String call
    ///
    /// - Parameters:
    ///   - method: RestApiMethod
    /// - Returns: String
    public func call(method: RestApiMethod) async throws -> String {
        throw NSError(domain: "RestApiManagerMock", code: 0, userInfo: nil)
    }
    
    // ---------------------------------------------------------------------
    // MARK: - Multipart
    // ---------------------------------------------------------------------
    
    /// Multipart Object call
    ///
    /// - Parameters:
    ///   - multipartData: MultipartData
    ///   - method: RestApiMethod
    /// - Returns: T
    public func call<T: Decodable>(multipartData: MultipartData, method: RestApiMethod) async throws -> T {
        throw NSError(domain: "RestApiManagerMock", code: 0, userInfo: nil)
    }
    
    /// Multipart Array call
    ///
    /// - Parameters:
    ///   - multipartData: MultipartData
    ///   - method: RestApiMethod
    /// - Returns: [T]
    public func callArray<T: Decodable>(multipartData: MultipartData, method: RestApiMethod) async throws -> [T] {
        throw NSError(domain: "RestApiManagerMock", code: 0, userInfo: nil)
    }
    
    /// Multipart String call
    ///
    /// - Parameters:
    ///   - multipartData: MultipartData
    ///   - method: RestApiMethod
    /// - Returns: String
    public func call(multipartData: MultipartData, method: RestApiMethod) async throws -> String {
        throw NSError(domain: "RestApiManagerMock", code: 0, userInfo: nil)
    }
}
