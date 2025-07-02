//
//  Analytics.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 29.06.2021.
//

import Foundation

public protocol AnalyticsService {
    func setupUserID()
    func logScreen(_ screen: Constants.Analytics.EventScreen)
    func logAction(_ action: Constants.Analytics.EventAction)
}
