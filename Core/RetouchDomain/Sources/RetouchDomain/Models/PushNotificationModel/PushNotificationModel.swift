public enum PushNotificationType: String, Decodable, Sendable {
    case none = ""
    case orderCompleted = "order_completed"
    case orderCanceled = "order_canceled"
}

public protocol PushNotificationModel {
    var code: PushNotificationType { get }
}

public struct OrderStatusChangedNotificationModel: PushNotificationModel, Decodable, Sendable {
    public let code: PushNotificationType
    public let orderId: String
    public let orderStatus: OrderStatus
    public let userGemCount: Int?
    public let orderStatusDescription: String?
}
