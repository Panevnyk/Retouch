//
//  RetouchGroupRestApiMethods.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 26.02.2021.
//

import Foundation

public enum RetouchGroupRestApiMethods: RestApiMethod {
    // Method
    case getList

    // URL
    private static let getListURL = "/api/groups"

    // RestApiData
    public var data: RestApiData {
        switch self {
        case .getList:
            return RestApiData(url: RestApiConstants.baseURL + RetouchGroupRestApiMethods.getListURL,
                               httpMethod: .get,
                               headers: defaultHeaders)
        }
    }
}
