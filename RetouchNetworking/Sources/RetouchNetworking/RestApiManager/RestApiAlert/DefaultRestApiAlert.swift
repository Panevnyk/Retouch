//
//  DefaultRestApiAlert.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 11/6/17.
//  Copyright © 2017 Panevnyk Vlad. All rights reserved.
//

import UIKit

/// DefaultRestApiAlert
public final class DefaultRestApiAlert: RestApiAlert {
    /// init
    public init() {}
    
    /// show
    ///
    /// - Parameter error: RestApiError
    @MainActor public func show(error: RestApiError) {
        show(title: "Error", message: error.details, completion: nil)
    }
    
    /// show
    ///
    /// - Parameters:
    ///   - title: title of UIAlertController
    ///   - message: message of UIAlertController
    ///   - completion: completion of UIAlertController
    @MainActor public func show(title: String, message: String, completion: (() -> Void)?) {
        guard let rootViewController = UIApplication.presentationViewController else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            completion?()
        })
        alert.addAction(okAction)
        rootViewController.present(alert, animated: true, completion: nil)
    }
}
