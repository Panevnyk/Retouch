//
//  RestApiManager.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 10/5/17.
//  Copyright © 2017 RestApiManager. All rights reserved.
//

import Foundation

/// RestApiManager
public protocol RestApiManager: Sendable {
    
    // ---------------------------------------------------------------------
    // MARK: - Properties
    // ---------------------------------------------------------------------
    
    /// URLSessionRAMDIContainer
    var container: RestApiManagerDIContainer { get }
    
    // ---------------------------------------------------------------------
    // MARK: - Simple requests
    // ---------------------------------------------------------------------
    
    /// Object call
    ///
    /// - Parameters:
    ///   - method: RestApiMethod
    /// - Returns: T
    func call<T: Decodable>(method: RestApiMethod) async throws -> T
    
    /// Array call
    ///
    /// - Parameters:
    ///   - method: RestApiMethod
    /// - Returns: [T]
    func callArray<T: Decodable>(method: RestApiMethod) async throws -> [T]
    
    /// String call
    ///
    /// - Parameters:
    ///   - method: RestApiMethod
    /// - Returns: String
    func call(method: RestApiMethod) async throws -> String
    
    // ---------------------------------------------------------------------
    // MARK: - Multipart
    // ---------------------------------------------------------------------
    
    /// Multipart Object call
    ///
    /// - Parameters:
    ///   - multipartData: MultipartData
    ///   - method: RestApiMethod
    /// - Returns: T
    func call<T: Decodable>(multipartData: MultipartData, method: RestApiMethod) async throws -> T
    
    /// Multipart Array call
    ///
    /// - Parameters:
    ///   - multipartData: MultipartData
    ///   - method: RestApiMethod
    /// - Returns: [T]
    func callArray<T: Decodable>(multipartData: MultipartData, method: RestApiMethod) async throws -> [T]
    
    /// Multipart String call
    ///
    /// - Parameters:
    ///   - multipartData: MultipartData
    ///   - method: RestApiMethod
    /// - Returns: String
    func call(multipartData: MultipartData, method: RestApiMethod) async throws -> String
}
