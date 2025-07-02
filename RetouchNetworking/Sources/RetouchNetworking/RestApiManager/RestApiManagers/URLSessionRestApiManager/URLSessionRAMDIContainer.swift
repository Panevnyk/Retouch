//
//  URLSessionRAMDIContainer.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 10/19/18.
//  Copyright © 2018 Panevnyk Vlad. All rights reserved.
//

import Foundation

/// URLSessionRAMDIContainer
public struct URLSessionRAMDIContainer: RestApiManagerDIContainer {
    /// URLSession
    public let urlSession: URLSession
    /// JSONDecoder
    public let jsonDecoder: JSONDecoder
    /// RestApiAlert
    public let restApiAlert: RestApiAlert
    /// RestApiActivityIndicator
    public let restApiActivityIndicator: RestApiActivityIndicator
    /// PrintingRequest
    public let printRequestInfo: Bool
    /// TimeoutInterval
    public let timeoutInterval: Double
    /// TimeoutInterval
    public let errorHandler: RestApiErrorHandler
    
    /// init
    ///
    /// - Parameters:
    ///   - urlSession: URLSession
    ///   - jsonDecoder: JSONDecoder
    ///   - restApiAlert: RestApiAlert
    ///   - restApiActivityIndicator: RestApiActivityIndicator
    ///   - printRequestInfo: Bool
    public init(urlSession: URLSession = URLSession.shared,
                jsonDecoder: JSONDecoder = JSONDecoder(),
                restApiAlert: RestApiAlert = DefaultRestApiAlert(),
                restApiActivityIndicator: RestApiActivityIndicator = DefaultRestApiActivityIndicator(),
                printRequestInfo: Bool = true,
                timeoutInterval: Double = 15.0,
                errorHandler: RestApiErrorHandler = DefaultRestApiErrorHandler()
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.restApiAlert = restApiAlert
        self.restApiActivityIndicator = restApiActivityIndicator
        self.printRequestInfo = printRequestInfo
        self.timeoutInterval = timeoutInterval
        self.errorHandler = errorHandler
    }
}
