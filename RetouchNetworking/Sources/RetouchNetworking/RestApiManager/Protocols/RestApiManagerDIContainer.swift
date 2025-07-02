//
//  RestApiManagerDIContainer.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 10/19/18.
//  Copyright © 2018 Panevnyk Vlad. All rights reserved.
//

import Foundation

/// RestApiManagerDIContainer
public protocol RestApiManagerDIContainer: Sendable {
    /// RestApiAlert
    var restApiAlert: RestApiAlert { get }
    /// RestApiActivityIndicator
    var restApiActivityIndicator: RestApiActivityIndicator { get }
    /// PrintingRequest
    var printRequestInfo: Bool { get }
    /// TimeoutInterval
    var timeoutInterval: Double { get }
    /// RestApiErrorHandler
    var errorHandler: RestApiErrorHandler { get }
}
