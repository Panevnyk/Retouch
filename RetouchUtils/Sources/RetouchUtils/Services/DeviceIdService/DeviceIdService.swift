//
//  DeviceIdService.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 22.02.2021.
//

import UIKit

@MainActor
public final class DeviceIdService {
    public static var deviceId: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
    }
}
