public final class RetouchTag: Decodable, @unchecked Sendable {
    public let id: String
    public let title: String
    public let price: Int
    public let orderNumber: Int
    public var tagDescription: String?

    public init(id: String,
                title: String,
                price: Int,
                orderNumber: Int,
                tagDescription: String? = nil
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.orderNumber = orderNumber
        self.tagDescription = tagDescription
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
