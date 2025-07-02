//
//  DefaultRestApiActivityIndicator.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 3/23/17.
//  Copyright © 2017 Devlight company. All rights reserved.
//

import UIKit

/// DefaultRestApiActivityIndicator
public final class DefaultRestApiActivityIndicator: RestApiActivityIndicator {
    /// RestApiActivityIndicatorView
    @MainActor private weak var activityIndicatorView: RestApiActivityIndicatorView?
    
    /// Init
    public init() {}
    
    /// show
    @MainActor public func show() {
        hide()
        createRestApiActivityIndicatorView()
    }

    /// show
    ///
    /// - Parameter view: onView
    @MainActor public func show(onView view: UIView) {
        hide()
        createRestApiActivityIndicatorView(onView: view)
    }
    
    /// hide
    @MainActor public func hide() {
        if let activityIndicatorView = self.activityIndicatorView {
            activityIndicatorView.hide()
        }
    }
    
    @MainActor private func createRestApiActivityIndicatorView() {
        if let vc = UIApplication.presentationViewController {
            createRestApiActivityIndicatorView(onView: vc.view)
        }
    }
    
    @MainActor private func createRestApiActivityIndicatorView(onView view: UIView) {
        let activityIndicatorView = RestApiActivityIndicatorView(frame: view.bounds)
        activityIndicatorView.addSuperviewUsingConstraints(superview: view)
        activityIndicatorView.setupView()
        activityIndicatorView.show()
        self.activityIndicatorView = activityIndicatorView
    }   
}
