//
//  RestApiMethod+Headers.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 12.11.2020.
//

import Foundation

extension RestApiMethod {
    var defaultHeaders: [String: String] {
        let parameters: [String: String] = [
            // FIXME: - Token issue
            RestApiConstants.token: "" // UserData.shared.token
        ]
        return parameters
    }

    var multipartDefaultHeaders: [String: String] {
        let parameters: [String: String] = [
            "Content-Type": "multipart/form-data; boundary=ABC_boundary",
            // FIXME: - Token issue
            RestApiConstants.token: "" // UserData.shared.token
        ]
        return parameters
    }
}
