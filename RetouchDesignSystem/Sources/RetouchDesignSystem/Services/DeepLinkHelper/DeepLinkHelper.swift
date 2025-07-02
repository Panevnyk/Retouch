//
//  DeepLinkHelper.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 25.03.2021.
//

import Foundation

public protocol DeepLinkHelperProtocol {
    func deepLinkType(for url: URL) -> DeepLinkType?
}

public final class DeepLinkHelper: DeepLinkHelperProtocol {
    public init() {}

    public func deepLinkType(for url: URL) -> DeepLinkType? {
        guard url.pathComponents.count >= 4 else { return nil }
        guard url.pathComponents[1] == "path-for-redirection" else { return nil }

        let method = url.pathComponents[2]
        let id = url.pathComponents[3]

        if method == "reset-password" && id.count > 0 {
            return .resetPassword(id)
        }

        return nil
    }
}

public enum DeepLinkType {
    case resetPassword(String) // ["/", "path-for-redirection", "reset-password", "${user.resetPasswordToken}"]
}
