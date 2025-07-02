//
//  GemsRestApiMethods.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 09.04.2021.
//

import Foundation

public enum GemsRestApiMethods: RestApiMethod {
    // Method
    case refill(GemsParameters)

    // URL
    private static let refillURL = "/api/gems/refill"

    // RestApiData
    public var data: RestApiData {
        switch self {
        case .refill(let parameters):
            return RestApiData(url: RestApiConstants.baseURL + GemsRestApiMethods.refillURL,
                               httpMethod: .post,
                               headers: defaultHeaders,
                               parameters: parameters)
        }
    }
}
