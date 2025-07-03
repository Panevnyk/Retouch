//
//  PushNotificationModel.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 07.05.2021.
//

public enum PushNotificationType: String, Decodable, Sendable {
    case none = ""
    case orderCompleted = "order_completed"
    case orderCanceled = "order_canceled"
}

public protocol PushNotificationModel {
    var code: PushNotificationType { get }
}
