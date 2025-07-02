//
//  GemsParameters.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 09.04.2021.
//

import Foundation

public struct GemsParameters: ParametersProtocol {
    public let refillAmount: String

    public init(refillAmount: String) {
        self.refillAmount = refillAmount
    }

    public var parametersValue: Parameters {
        let parameters: [String: Any] = [
            "refillGemsCount": refillAmount
        ]

        return parameters
    }
}
