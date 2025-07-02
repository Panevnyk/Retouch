//
//  RetouchGroup.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 11.02.2021.
//

public final class RetouchGroup: Decodable, @unchecked Sendable {
    public var id: String = ""
    public var title: String = ""
    public var image: String = ""
    public var price: Int = 0
    public var orderNumber: Int = 0
    public var tags: [RetouchTag] = []
}
