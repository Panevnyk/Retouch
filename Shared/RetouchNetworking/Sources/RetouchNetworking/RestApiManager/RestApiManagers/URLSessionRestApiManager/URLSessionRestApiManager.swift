//
//  URLSessionRestApiManager.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 10/6/17.
//  Copyright © 2017 RestApiManager. All rights reserved.
//

import Foundation

/// URLSessionRestApiManager
public final class URLSessionRestApiManager: RestApiManager {
    
    // ---------------------------------------------------------------------
    // MARK: - Properties
    // ---------------------------------------------------------------------
    
    /// RestApiManagerDIContainer
    public var container: RestApiManagerDIContainer {
        return urlSessionRAMDIContainer
    }
    
    /// URLSessionRAMDIContainer
    let urlSessionRAMDIContainer: URLSessionRAMDIContainer
    
    // ---------------------------------------------------------------------
    // MARK: - Inits
    // ---------------------------------------------------------------------
    
    /// Init with URLSessionRestApiManager properties
    ///
    /// - Parameter urlSessionRAMDIContainer: URLSessionRAMDIContainer
    public init(urlSessionRAMDIContainer: URLSessionRAMDIContainer = URLSessionRAMDIContainer()) {
        self.urlSessionRAMDIContainer = urlSessionRAMDIContainer
    }

    // ---------------------------------------------------------------------
    // MARK: - Simple requests
    // ---------------------------------------------------------------------
 
    /// Object call
    ///
    /// - Parameters:
    ///   - method: RestApiMethod
    /// - Returns: T
    public func call<T: Decodable>(method: RestApiMethod) async throws -> T {
        return try await load(method: method)
    }
    
    /// Array call
    ///
    /// - Parameters:
    ///   - method: RestApiMethod
    /// - Returns: [T]
    public func callArray<T: Decodable>(method: RestApiMethod) async throws -> [T] {
        try await load(method: method)
    }
    
    /// String call
    ///
    /// - Parameters:
    ///   - method: RestApiMethod
    /// - Returns: String
    public func call(method: RestApiMethod) async throws -> String {
        try await load(method: method)
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
        try await loadMultipart(multipartData: multipartData, method: method)
    }
    
    /// Multipart Array call
    ///
    /// - Parameters:
    ///   - multipartData: MultipartData
    ///   - method: RestApiMethod
    /// - Returns: [T]
    public func callArray<T: Decodable>(multipartData: MultipartData, method: RestApiMethod) async throws -> [T] {
        try await loadMultipart(multipartData: multipartData, method: method)
    }
    
    /// Multipart String call
    ///
    /// - Parameters:
    ///   - multipartData: MultipartData
    ///   - method: RestApiMethod
    /// - Returns: String
    public func call(multipartData: MultipartData, method: RestApiMethod) async throws -> String {
        try await loadMultipart(multipartData: multipartData, method: method)
    }
}

// MARK: - Load simple data
private extension URLSessionRestApiManager {
    func load<T: Decodable>(method: RestApiMethod) async throws -> T {
        guard let request = request(method: method) else {
            throw DefaultRestApiError.canNotCreateURLRequest
        }
        
        let (data, response) = try await urlSessionRAMDIContainer
            .urlSession
            .data(for: request)
        
        printDataResponse(response, request: request, data: data)
        
        if let error = container.errorHandler.handle(urlResponse: response, data: data) {
            throw error
        }

        return try await decode(data: data, keyPath: method.data.keyPath)
    }
}

// MARK: - Load multipart data
private extension URLSessionRestApiManager {
    func loadMultipart<T: Decodable>(multipartData: MultipartData, method: RestApiMethod) async throws -> T {
        guard let request = request(method: method) else {
            throw DefaultRestApiError.canNotCreateURLRequest
        }
        
        let (data, response) = try await urlSessionRAMDIContainer
            .urlSession
            .upload(for: request, from: multipartData.data)
        
        printDataResponse(response, request: request, data: data)
        
        if let error = container.errorHandler.handle(urlResponse: response, data: data) {
            throw error
        }

        return try await decode(data: data, keyPath: method.data.keyPath)
    }
}

// MARK: - Decode
private extension URLSessionRestApiManager {
    func decode<T: Decodable>(
        data: Data,
        keyPath: String?) async throws -> T {
        let object = try urlSessionRAMDIContainer
            .jsonDecoder
            .decode(T.self, from: data, keyPath: keyPath)
        return object
    }
}
