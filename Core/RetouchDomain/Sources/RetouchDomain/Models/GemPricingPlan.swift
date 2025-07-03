//
//  GemPricingPlan.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 27.02.2021.
//

public final class GemPricingPlan: Decodable {
    public var id: String
    public var countOfGems: Int
    public var countOfUSD: Double
    public var bonusesDescription: String?

    // MARK: - Init
    public init(id: String,
                countOfGems: Int,
                countOfUSD: Double,
                bonusesDescription: String?
    ) {
        self.id = id
        self.countOfGems = countOfGems
        self.countOfUSD = countOfUSD
        self.bonusesDescription = bonusesDescription
    }
}
