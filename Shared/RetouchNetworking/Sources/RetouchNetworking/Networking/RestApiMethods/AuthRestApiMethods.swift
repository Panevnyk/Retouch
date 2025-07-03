//
//  RepositoriesRestApiMethods.swift
//  GitRepositoriesTestApp
//
//  Created by Vladyslav Panevnyk on 02.07.2020.
//  Copyright © 2020 example company. All rights reserved.
//

import Foundation

public enum AuthRestApiMethods: RestApiMethod {
    // Method
    case signinWithApple(SigninWithAppleParameters)
    case signinWithDeviceId(SigninWithDeviceIdParameters)
    case signup(SignupParameters)
    case signin(SigninParameters)
    case currentUser
    case forgotPassword(ForgotPasswordParameters)
    case resetPassword(ResetPasswordParameters)
    case removeAccount
    case signout
    case updatePushNotificationToken(UpdatePushNotificationTokenParameters)

    // URL
    private static let signinWithAppleURL = "/api/auth/signinWithApple"
    private static let signinWithDeviceIdURL = "/api/auth/signinWithDeviceId"
    private static let signupURL = "/api/auth/signup"
    private static let signinURL = "/api/auth/signin"
    private static let currentUserURL = "/api/auth/currentUser"
    private static let forgotPasswordURL = "/api/auth/forgotPassword"
    private static let resetPasswordURL = "/api/auth/resetPassword"
    private static let removeAccountURL = "/api/auth"
    private static let signoutURL = "/api/auth/signout"
    private static let updatePushNotificationTokenUrl = "/api/auth/updateDeviceToken"

    // RestApiData
    public var data: RestApiData {
        switch self {
        case .signinWithApple(let parameters):
            return RestApiData(url: RestApiConstants.baseURL + AuthRestApiMethods.signinWithAppleURL,
                               httpMethod: .post,
                               parameters: parameters)
        case .signinWithDeviceId(let parameters):
            return RestApiData(url: RestApiConstants.baseURL + AuthRestApiMethods.signinWithDeviceIdURL,
                               httpMethod: .post,
                               parameters: parameters)
        case .signup(let parameters):
            return RestApiData(url: RestApiConstants.baseURL + AuthRestApiMethods.signupURL,
                               httpMethod: .post,
                               parameters: parameters)
        case .signin(let parameters):
            return RestApiData(url: RestApiConstants.baseURL + AuthRestApiMethods.signinURL,
                               httpMethod: .post,
                               parameters: parameters)
        case .currentUser:
            return RestApiData(url: RestApiConstants.baseURL + AuthRestApiMethods.currentUserURL,
                               httpMethod: .get,
                               headers: defaultHeaders)
        case .forgotPassword(let parameters):
            return RestApiData(url: RestApiConstants.baseURL + AuthRestApiMethods.forgotPasswordURL,
                               httpMethod: .post,
                               parameters: parameters)
        case .resetPassword(let parameters):
            return RestApiData(url: RestApiConstants.baseURL + AuthRestApiMethods.resetPasswordURL,
                               httpMethod: .post,
                               parameters: parameters)
        case .removeAccount:
            return RestApiData(url: RestApiConstants.baseURL + AuthRestApiMethods.removeAccountURL,
                               httpMethod: .delete)
        case .signout:
            return RestApiData(url: RestApiConstants.baseURL + AuthRestApiMethods.signoutURL,
                               httpMethod: .post)
        case .updatePushNotificationToken(let parameters):
            return RestApiData(url: RestApiConstants.baseURL + AuthRestApiMethods.updatePushNotificationTokenUrl,
                               httpMethod: .post,
                               headers: defaultHeaders,
                               parameters: parameters)
        }
    }
}
