//
//  RestApiErrorHandler.swift
//  RetouchNetworking
//
//  Created by Vladyslav Panevnyk  on 19.06.2025.
//

import Foundation

/// RestApiError
public protocol RestApiErrorHandler: Sendable  {
    func handle(error: Error) -> Error
    func handle(urlResponse: URLResponse, data: Data) -> Error?
}

public struct DefaultRestApiErrorHandler: RestApiErrorHandler {
    public init() {}

    public func handle(error: Error) -> Error {
        return error
    }

    public func handle(urlResponse: URLResponse, data: Data) -> Error? {
        return nil
    }
}
