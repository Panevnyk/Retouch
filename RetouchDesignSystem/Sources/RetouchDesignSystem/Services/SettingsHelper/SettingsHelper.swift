//
//  SettingsHelper.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 17.02.2021.
//

import UIKit

@MainActor
public final class SettingsHelper {
    public static func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsUrl)
    }
}
