public final class RetouchGroup: Decodable, @unchecked Sendable {
    public let id: String
    public let title: String
    public let image: String
    public let price: Int
    public let orderNumber: Int
    public var tags: [RetouchTag] = []
    
    public init(
        id: String,
        title: String,
        image: String,
        price: Int,
        orderNumber: Int,
        tags: [RetouchTag]
    ) {
        self.id = id
        self.title = title
        self.image = image
        self.price = price
        self.orderNumber = orderNumber
        self.tags = tags
    }
}
