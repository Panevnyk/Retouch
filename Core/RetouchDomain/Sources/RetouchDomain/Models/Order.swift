public struct Order: Decodable, @unchecked Sendable {
    public let id: String
    public let userId: String
    public let adminId: String?

    public let client: String
    public let designer: String?

    public let beforeImage: String?
    public var afterImage: String?
    public let selectedRetouchGroups: [SelectedRetouchGroup]
    public let price: Int

    public let creationDate: Double // millis
    public let finishDate: Double   // millis
    public let calculatedWaitingTime: Double // millis

    public var rating: Int?
    public var isPayed: Bool
    public var isPayedForUrgent: Bool
    public var isRedo: Bool
    public var redoDescription: String?
    public let isNewOrder: Bool
    public var status: OrderStatus
    public var statusDescription: String?

    public var isCompleted: Bool { status == .completed }

    // MARK: - Init
    public init(id: String,
                userId: String,
                adminId: String?,

                client: String,
                designer: String?,

                beforeImage: String?,
                afterImage: String?,
                selectedRetouchGroups: [SelectedRetouchGroup],
                price: Int,

                creationDate: Double,
                finishDate: Double,
                calculatedWaitingTime: Double,

                rating: Int?,
                isPayed: Bool,
                isPayedForUrgent: Bool,
                isRedo: Bool,
                redoDescription: String?,
                isNewOrder: Bool,
                status: OrderStatus,
                statusDescription: String?
    ) {
        self.id = id
        self.userId = userId
        self.adminId = adminId

        self.client = client
        self.designer = designer

        self.beforeImage = beforeImage
        self.afterImage = afterImage
        self.selectedRetouchGroups = selectedRetouchGroups
        self.price = price

        self.creationDate = creationDate
        self.finishDate = finishDate
        self.calculatedWaitingTime = calculatedWaitingTime

        self.rating = rating
        self.isPayed = isPayed
        self.isPayedForUrgent = isPayedForUrgent
        self.isRedo = isRedo
        self.redoDescription = redoDescription
        self.isNewOrder = isNewOrder
        self.status = status
        self.statusDescription = statusDescription
    }
}

public enum OrderStatus: String, Decodable, Sendable {
    case waiting
    case confirmed
    case canceled
    case waitingForReview
    case inReview
    case redoByLeadDesigner
    case completed
}
