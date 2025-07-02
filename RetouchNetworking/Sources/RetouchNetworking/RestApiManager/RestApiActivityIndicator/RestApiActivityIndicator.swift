//
//  RestApiActivityIndicator.swift
//  RestApiManager
//
//  Created by Panevnyk Vlad on 2/20/18.
//  Copyright © 2018 Panevnyk Vlad. All rights reserved.
//

import UIKit

/// RestApiActivityIndicator
public protocol RestApiActivityIndicator: Sendable  {
    @MainActor func show()
    @MainActor func show(onView view: UIView)
    @MainActor func hide()
}
