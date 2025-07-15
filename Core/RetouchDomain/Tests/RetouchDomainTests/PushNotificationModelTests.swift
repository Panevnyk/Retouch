import Foundation
import Testing
@testable import RetouchDomain

@Suite(.tags(.model))
struct PushNotificationTests {
    
    @Test
    func decodesValidPushNotificationTypes() throws {
        let completed = try JSONDecoder().decode(PushNotificationType.self, from: "\"order_completed\"".data(using: .utf8)!)
        let canceled = try JSONDecoder().decode(PushNotificationType.self, from: "\"order_canceled\"".data(using: .utf8)!)
        let none = try JSONDecoder().decode(PushNotificationType.self, from: "\"\"".data(using: .utf8)!)
        
        #expect(completed == .orderCompleted)
        #expect(canceled == .orderCanceled)
        #expect(none == .none)
    }

    @Test
    func throwsWhenPushNotificationTypeUnknown() {
        let json = "\"invalid_type\"".data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            _ = try JSONDecoder().decode(PushNotificationType.self, from: json)
        })
    }
    
    // MARK: - OrderStatusChangedNotificationModel
    
    @Test
    func decodesFullNotificationModel() throws {
        let json = """
        {
            "code": "order_completed",
            "orderId": "12345",
            "orderStatus": "completed",
            "userGemCount": 50,
            "orderStatusDescription": "Your order is done"
        }
        """.data(using: .utf8)!

        let model = try JSONDecoder().decode(OrderStatusChangedNotificationModel.self, from: json)

        #expect(model.code == .orderCompleted)
        #expect(model.orderId == "12345")
        #expect(model.orderStatus == .completed)
        #expect(model.userGemCount == 50)
        #expect(model.orderStatusDescription == "Your order is done")
    }

    @Test
    func decodesWhenOptionalFieldsAreMissing() throws {
        let json = """
        {
            "code": "order_canceled",
            "orderId": "67890",
            "orderStatus": "canceled"
        }
        """.data(using: .utf8)!

        let model = try JSONDecoder().decode(OrderStatusChangedNotificationModel.self, from: json)

        #expect(model.code == .orderCanceled)
        #expect(model.orderId == "67890")
        #expect(model.orderStatus == .canceled)
        #expect(model.userGemCount == nil)
        #expect(model.orderStatusDescription == nil)
    }

    @Test
    func throwsWhenRequiredFieldIsMissing() {
        let json = """
        {
            "code": "order_completed",
            "orderStatus": "completed"
        }
        """.data(using: .utf8)!

        #expect(throws: DecodingError.self, performing: {
            _ = try JSONDecoder().decode(OrderStatusChangedNotificationModel.self, from: json)
        })
    }
}
