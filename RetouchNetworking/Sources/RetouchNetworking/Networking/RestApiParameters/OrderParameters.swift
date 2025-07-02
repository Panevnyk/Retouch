//
//  OrderParameters.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 28.01.2021.
//

import Foundation

public struct CreateOrderMultipartData: MultipartData, Sendable {
    public let boundary: String
    public let parameters: [String: String]?
    public let multipartObjects: [MultipartObject]?

    public init(multipartObjects: [MultipartObject]?) {
        self.boundary = "ABC_boundary"
        self.parameters = nil
        self.multipartObjects = multipartObjects
    }
}

public struct OrderRatingParameters: ParametersProtocol, Sendable {
    public let id: String
    public let rating: Int
    
    public init(id: String, rating: Int) {
        self.id = id
        self.rating = rating
    }
    
    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            "rating": rating
        ]

        return parameters
    }
}

public struct RemoveOrderParameters: ParametersProtocol, Sendable {
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
    
    public var parametersValue: Parameters {
        return [:]
    }
}

public struct CreateOrderParameters: ParametersProtocol, Sendable {
    public let beforeImage: String
    public let selectedRetouchGroups: [SelectedRetouchGroupParameters]
    public let price: Int
    public let isFreeOrder: Bool

    public init(beforeImage: String,
                selectedRetouchGroups: [SelectedRetouchGroupParameters],
                price: Int,
                isFreeOrder: Bool) {
        self.beforeImage = beforeImage
        self.selectedRetouchGroups = selectedRetouchGroups
        self.price = price
        self.isFreeOrder = isFreeOrder
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            RestApiConstants.platform: Constants.platform,
            "beforeImage": beforeImage,
            "selectedRetouchGroups": selectedRetouchGroups.map { $0.parametersValue },
            "price": price,
            "isFreeOrder": isFreeOrder
        ]

        return parameters
    }
}

public struct SelectedRetouchGroupParameters: ParametersProtocol, Sendable {
    public let retouchGroupId: String
    public let selectedRetouchTags: [SelectedRetouchTagParameters]
    public let retouchGroupTitle: String
    public let descriptionForDesigner: String

    public init(retouchGroupId: String,
                selectedRetouchTags: [SelectedRetouchTagParameters],
                retouchGroupTitle: String,
                descriptionForDesigner: String) {
        self.retouchGroupId = retouchGroupId
        self.selectedRetouchTags = selectedRetouchTags
        self.retouchGroupTitle = retouchGroupTitle
        self.descriptionForDesigner = descriptionForDesigner
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            "retouchGroupId": retouchGroupId,
            "selectedRetouchTags": selectedRetouchTags.map({ $0.parametersValue }),
            "retouchGroupTitle": retouchGroupTitle,
            "descriptionForDesigner": descriptionForDesigner
        ]

        return parameters
    }
}

public struct SelectedRetouchTagParameters: ParametersProtocol, Sendable {
    public let retouchTagId: String
    public let retouchTagTitle: String
    public let retouchTagPrice: Int
    public let retouchTagDescription: String?

    public init(retouchTagId: String,
                retouchTagTitle: String,
                retouchTagPrice: Int,
                retouchTagDescription: String?) {
        self.retouchTagId = retouchTagId
        self.retouchTagTitle = retouchTagTitle
        self.retouchTagPrice = retouchTagPrice
        self.retouchTagDescription = retouchTagDescription
    }

    public var parametersValue: Parameters {
        var parameters: [String: Any] = [
            "retouchTagId": retouchTagId,
            "retouchTagTitle": retouchTagTitle,
            "retouchTagPrice": retouchTagPrice
        ]
        
        if let retouchTagDescription = retouchTagDescription {
            parameters["retouchTagDescription"] = retouchTagDescription
        }

        return parameters
    }
}

public struct RedoOrderParameters: ParametersProtocol, Sendable {
    public let id: String
    public let redoDescription: String

    public init(id: String, redoDescription: String) {
        self.id = id
        self.redoDescription = redoDescription
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            "redoDescription": redoDescription
        ]

        return parameters
    }
}

public struct IsNewOrderParameters: ParametersProtocol, Sendable {
    public let id: String
    public let isNewOrder: Bool

    public init(id: String, isNewOrder: Bool) {
        self.id = id
        self.isNewOrder = isNewOrder
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            "isNewOrder": isNewOrder
        ]

        return parameters
    }
}
