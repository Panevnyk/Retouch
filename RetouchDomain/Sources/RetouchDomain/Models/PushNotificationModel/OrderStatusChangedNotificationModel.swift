//
//  OrderStatusChangedNotificationModel.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 07.05.2021.
//

public struct OrderStatusChangedNotificationModel: PushNotificationModel, Sendable {
    public let code: PushNotificationType
    public let orderId: String
    public let orderStatus: OrderStatus
    public let userGemCount: Int?
    public let orderStatusDescription: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? container.decode(PushNotificationType.self, forKey: .code)) ?? .none
        orderId = (try? container.decode(String.self, forKey: .orderId)) ?? ""
        orderStatus = (try? container.decode(OrderStatus.self, forKey: .orderStatus)) ?? .waiting
        userGemCount = Int((try? container.decode(String?.self, forKey: .userGemCount)) ?? "")
        orderStatusDescription = try? container.decode(String?.self, forKey: .orderStatusDescription)
     }
    
    enum CodingKeys: String, CodingKey {
        case code, orderId, orderStatus, userGemCount, orderStatusDescription
    }
}
