//
//  IAPProduct.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 22.04.2021.
//

import StoreKit

public enum IAPProduct: String, CaseIterable {
    case gems30 = "retoucherThirtyGemsProductID"
    case gems50 = "retoucherFiftyGemsProductID"
    case gems110 = "retoucherOneHundredTenGemsProductID"
    case gems180 = "retoucherOneHundredEightyGemsProductID"
    case gems240 = "retoucherTwoHundredFortyGemsProductID"
    case gems300 = "retoucherThreeHundredGemsProductID"
    case gems500 = "retoucherFiveHundredGemsProductID"
    case gems1000 = "retoucherOneThousandGemsProductID"

    public var gemsCount: Int {
        switch self {
        case .gems30: return 30
        case .gems50: return 50
        case .gems110: return 110
        case .gems180: return 180
        case .gems240: return 240
        case .gems300: return 300
        case .gems500: return 500
        case .gems1000: return 1000
        }
    }
    
    public var gemsPriceUSD: Double {
        switch self {
        case .gems30: return 2.49
        case .gems50: return 3.49
        case .gems110: return 6.99
        case .gems180: return 10.99
        case .gems240: return 12.99
        case .gems300: return 14.99
        case .gems500: return 24.99
        case .gems1000: return 42.99
        }
    }

    public var gemsDescription: String? {
        switch self {
        case .gems30: return nil
        case .gems50: return "+20% bonuses"
        case .gems110: return "+35% bonuses"
        case .gems180: return "+50% bonuses"
        case .gems240: return "+70% bonuses"
        case .gems300: return "+85% bonuses"
        case .gems500: return "+100% bonuses"
        case .gems1000: return "+125% bonuses"
        }
    }
}

public struct IAPProductResponse {
    public let iapProduct: IAPProduct
    
    public let price: NSDecimalNumber
    public let currencyCode: String
    public let gemsCount: Int
    public let gemsDescription: String?
    public let productIdentifier: String
    public let localizedTitle: String
    public let localizedDescription: String

    public init(product: SKProduct, iapProduct: IAPProduct) {
        self.iapProduct = iapProduct
        self.price = product.price
        self.currencyCode = product.priceLocale.currencyCode ?? ""
        self.gemsCount = iapProduct.gemsCount
        self.gemsDescription = iapProduct.gemsDescription
        self.productIdentifier = product.productIdentifier
        self.localizedTitle = product.localizedTitle
        self.localizedDescription = product.localizedDescription
    }
}
