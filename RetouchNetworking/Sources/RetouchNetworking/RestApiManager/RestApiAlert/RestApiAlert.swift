//
//  RestApiAlert.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 2/20/18.
//  Copyright © 2018 Panevnyk Vlad. All rights reserved.
//

/// RestApiAlert
public protocol RestApiAlert: Sendable {
    @MainActor
    func show(error: RestApiError)

    @MainActor
    func show(title: String, message: String, completion: (() -> Void)?)
}
