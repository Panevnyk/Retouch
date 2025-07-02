//
//  OrderRestApiMethods.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 28.01.2021.
//

import Foundation

public enum OrderRestApiMethods: RestApiMethod {
    // Method
    case getList
    case create(CreateOrderParameters)
    case uploadBeforeImage
    case redoOrder(RedoOrderParameters)
    case sendRating(OrderRatingParameters)
    case isNewOrder(IsNewOrderParameters)
    case removeOrder(RemoveOrderParameters)

    // URL
    private static let getListURL = "/api/orders/currentUser"
    private static let createURL = "/api/orders"
    private static let uploadBeforeImageURL = "/api/orders/uploadBefore"
    private static let redoOrderURL = "/api/orders/redo/"
    private static let sendRatingURL = "/api/order/rating/"
    private static let isNewOrderURL = "/api/order/isNew/"
    private static let removeOrderURL = "/api/orders/"

    // RestApiData
    public var data: RestApiData {
        switch self {
        case .getList:
            return RestApiData(url: RestApiConstants.baseURL
                                + OrderRestApiMethods.getListURL,
                               httpMethod: .get,
                               headers: defaultHeaders)
        case .create(let parameters):
            return RestApiData(url: RestApiConstants.baseURL + OrderRestApiMethods.createURL,
                               httpMethod: .post,
                               headers: defaultHeaders,
                               parameters: parameters)
        case .uploadBeforeImage:
            return RestApiData(url: RestApiConstants.baseURL + OrderRestApiMethods.uploadBeforeImageURL,
                               httpMethod: .post,
                               headers: multipartDefaultHeaders)
        case .redoOrder(let parameters):
            return RestApiData(url: RestApiConstants.baseURL
                                + OrderRestApiMethods.redoOrderURL
                                + parameters.id,
                               httpMethod: .post,
                               headers: defaultHeaders,
                               parameters: parameters)
        case .sendRating(let parameters):
            return RestApiData(url: RestApiConstants.baseURL
                                + OrderRestApiMethods.sendRatingURL
                                + parameters.id,
                               httpMethod: .post,
                               headers: defaultHeaders,
                               parameters: parameters)
            
        case .isNewOrder(let parameters):
            return RestApiData(url: RestApiConstants.baseURL
                                + OrderRestApiMethods.isNewOrderURL
                                + parameters.id,
                               httpMethod: .post,
                               headers: defaultHeaders,
                               parameters: parameters)
        case .removeOrder(let parameters):
            return RestApiData(url: RestApiConstants.baseURL
                                + OrderRestApiMethods.removeOrderURL
                                + parameters.id,
                               httpMethod: .delete,
                               headers: defaultHeaders)
        }
    }
}
