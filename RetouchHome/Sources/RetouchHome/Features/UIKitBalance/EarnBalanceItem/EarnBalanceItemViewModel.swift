//
//  EarnBalanceItemViewModel.swift
//  RetouchHome
//
//  Created by Panevnyk Vlad on 11.07.2022.
//

import RetouchUtils
import RetouchDesignSystem

public protocol EarnBalanceItemViewModelProtocol {
    var diamondPrice: String { get }
    var descriptionTitle: String { get }
    var earnCreditsType: EarnCreditsType { get }
    var isAvailable: Bool { get }
}

public final class EarnBalanceItemViewModel: EarnBalanceItemViewModelProtocol {
    public let diamondPrice: String
    public let descriptionTitle: String
    public let earnCreditsType: EarnCreditsType
    public let isAvailable: Bool

    public init(diamondPrice: String,
                descriptionTitle: String,
                earnCreditsType: EarnCreditsType,
                isAvailable: Bool) {
        self.diamondPrice = diamondPrice
        self.descriptionTitle = descriptionTitle
        self.earnCreditsType = earnCreditsType
        self.isAvailable = isAvailable
    }
}
