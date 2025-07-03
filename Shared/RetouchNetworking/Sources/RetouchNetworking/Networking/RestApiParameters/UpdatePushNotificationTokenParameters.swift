//
//  RegisterPushNotificationParameters.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 23.03.2021.
//

import UIKit
import Foundation

public class UpdatePushNotificationTokenParameters: ParametersProtocol {
    public let fcmToken: String

    public init(fcmToken: String) {
        self.fcmToken = fcmToken
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            RestApiConstants.fcmToken: fcmToken,
            ]
        return parameters
    }
}
