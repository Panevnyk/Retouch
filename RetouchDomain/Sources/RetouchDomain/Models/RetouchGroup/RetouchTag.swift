//
//  RetouchTag.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 11.02.2021.
//

public final class RetouchTag: Decodable, @unchecked Sendable {
    public var id: String
    public var title: String
    public var price: Int
    public var orderNumber: Int
    public var tagDescription: String?
    
    // CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, title, price, orderNumber, tagDescription
    }

    // MARK: - Init
    public init(id: String,
                title: String,
                price: Int,
                orderNumber: Int) {
        self.id = id
        self.title = title
        self.price = price
        self.orderNumber = orderNumber
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        price = (try? container.decode(Int.self, forKey: .price)) ?? 5
        orderNumber = (try? container.decode(Int.self, forKey: .orderNumber)) ?? 0
        tagDescription = (try? container.decode(String.self, forKey: .tagDescription)) ?? ""
    }
}

// MARK: - Equatable
extension RetouchTag: Equatable {
    public static func == (lhs: RetouchTag, rhs: RetouchTag) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.price == rhs.price &&
        lhs.orderNumber == rhs.orderNumber &&
        lhs.tagDescription == rhs.tagDescription
    }
}
