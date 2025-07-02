//
//  BalanceItemViewModel.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 17.02.2021.
//

import RetouchUtils
import RetouchDesignSystem

public protocol BalanceItemViewModelProtocol {
    var diamondPrice: String { get }
    var usdPrice: String { get }
    var bonuses: String? { get }
}

public final class BalanceItemViewModel: BalanceItemViewModelProtocol {
    public let diamondPrice: String
    public let usdPrice: String
    public let bonuses: String?

    public init(diamondPrice: String,
                usdPrice: String,
                bonuses: String?)
    {
        self.diamondPrice = diamondPrice
        self.usdPrice = usdPrice
        self.bonuses = bonuses
    }

    public init(productResponse: IAPProductResponse) {
        self.diamondPrice = String(productResponse.gemsCount)
        self.usdPrice = productResponse.price.stringValue + " " + productResponse.currencyCode
        self.bonuses = productResponse.gemsDescription
    }
}
