//
//  AuthParameters.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 12.11.2020.
//

import Foundation

enum Constants {
    static let currentClientApp = "Picso"
    static let platform = "IOS"
}

public struct SigninWithAppleParameters: ParametersProtocol {
    public let appleUserId: String
    public let fullName: String?
    public let email: String?
    public let deviceId: String
    public let freeGemsAvailable: Bool

    public init(appleUserId: String,
                fullName: String? = nil,
                email: String? = nil,
                deviceId: String,
                freeGemsAvailable: Bool
    ) {
        self.appleUserId = appleUserId
        self.fullName = fullName
        self.email = email
        self.deviceId = deviceId // DeviceHelper.deviceId
        self.freeGemsAvailable = freeGemsAvailable // DeviceHelper.freeGemsAvailable
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            RestApiConstants.appleUserId: appleUserId,
            RestApiConstants.fullName: fullName ?? "",
            RestApiConstants.email: email ?? "",
            RestApiConstants.deviceId: deviceId,
            RestApiConstants.clientApp: Constants.currentClientApp,
            RestApiConstants.platform: Constants.platform,
            RestApiConstants.freeGemsAvailable: freeGemsAvailable
            ]
        return parameters
    }
}

public struct SigninWithDeviceIdParameters: ParametersProtocol {
    public let deviceId: String
    public let freeGemsAvailable: Bool
    
    public init(
        deviceId: String,
        freeGemsAvailable: Bool
    ) {
        self.deviceId = deviceId
        self.freeGemsAvailable = freeGemsAvailable
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            RestApiConstants.deviceId: deviceId,
            RestApiConstants.clientApp: Constants.currentClientApp,
            RestApiConstants.platform: Constants.platform,
            RestApiConstants.freeGemsAvailable: freeGemsAvailable
            ]
        return parameters
    }
}

public struct SigninParameters: ParametersProtocol {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            RestApiConstants.email: email,
            RestApiConstants.password: password,
            ]
        return parameters
    }
}

public struct SignupParameters: ParametersProtocol {
    public let email: String
    public let password: String
    public let deviceId: String
    public let freeGemsAvailable: Bool

    public init(email: String,
                password: String,
                deviceId: String,
                freeGemsAvailable: Bool
    ) {
        self.email = email
        self.password = password
        self.deviceId = deviceId
        self.freeGemsAvailable = freeGemsAvailable
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            RestApiConstants.email: email,
            RestApiConstants.password: password,
            RestApiConstants.deviceId: deviceId,
            RestApiConstants.clientApp: Constants.currentClientApp,
            RestApiConstants.platform: Constants.platform,
            RestApiConstants.freeGemsAvailable: freeGemsAvailable
            ]
        return parameters
    }
}

public struct ForgotPasswordParameters: ParametersProtocol {
    public let email: String

    public init(email: String) {
        self.email = email
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            RestApiConstants.email: email,
            ]
        return parameters
    }
}

public struct ResetPasswordParameters: ParametersProtocol {
    public let password: String
    public let resetPasswordToken: String

    public init(password: String, resetPasswordToken: String) {
        self.password = password
        self.resetPasswordToken = resetPasswordToken
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            RestApiConstants.password: password,
            RestApiConstants.resetPasswordToken: resetPasswordToken
            ]
        return parameters
    }
}
