public final class Order: Decodable, @unchecked Sendable {
    public var id: String
    public var userId: String
    public var adminId: String?

    public var client: String
    public var designer: String?

    public var beforeImage: String?
    public var afterImage: String?
    public var selectedRetouchGroups: [SelectedRetouchGroup]
    public var price: Int

    public var creationDate: Double // milisec
    public var finishDate: Double // milisec
    public var calculatedWaitingTime: Double // milisec

    public var rating: Int?
    public var isPayed: Bool
    public var isPayedForUrgent: Bool
    public var isRedo: Bool
    public var redoDescription: String?
    public var isNewOrder: Bool
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
    case waiting = "waiting"
    case confirmed = "confirmed"
    case canceled = "canceled"
    case waitingForReview = "waitingForReview"
    case inReview = "inReview"
    case redoByLeadDesigner = "redoByLeadDesigner"
    case completed = "completed"
}
