////
////  PushNotificationHelper.swift
////  RetouchDesignSystem
////
////  Created by Vladyslav Panevnyk on 23.03.2021.
////
//
//import UIKit
//import Firebase
//import UserNotifications
//import RetouchNetworking
//
//public protocol PushNotificationServiceProtocol {
//    var fcmToken: String? { get set }
//    var isLogined: Bool { get set }
//
//    func setup()
//    func setPushStatus(_ status: PushStatus)
//    func handlePushNotification(appData: [String: Any])
//}
//
//final public class PushNotificationService: PushNotificationServiceProtocol {
//    // MARK: - Properties
//    // Boundaries
//    private let jsonDecoder: JSONDecoder
//    private let restApiManager: RestApiManager
//    private let userDefaults = UserDefaults.standard
//    private let ordersLoader: OrdersLoaderProtocol
//    private let dataLoader: DataLoaderProtocol
//
//    // Static
//    private static let tokenKey = "pushNotificationTokenKey"
//    private static let tokenValue = "pushNotificationTokenValue"
//
//    public var isLogined = false {
//        didSet {
//            if isLogined {
//                setPushStatus(.enable)
//            } else {
//                isTokenSendedToServer = false
//            }
//        }
//    }
//
//    public var fcmToken: String? {
//        get {
//            let fcmToken = userDefaults.string(forKey: PushNotificationService.tokenValue)
//            print("\n\n-------------------------------------------------------------")
//            print("Token got from UserDefaults: \(String(describing: fcmToken))")
//            print("-------------------------------------------------------------\n\n")
//            return fcmToken
//        }
//        set {
//            userDefaults.set(newValue, forKey: PushNotificationService.tokenValue)
//            setPushStatus(.enable)
//        }
//    }
//
//    private var isTokenSendedToServer: Bool {
//        get { userDefaults.bool(forKey: PushNotificationService.tokenKey) }
//        set { userDefaults.set(newValue, forKey: PushNotificationService.tokenKey) }
//    }
//
//    // MARK: - Init
//    public init(jsonDecoder: JSONDecoder,
//                restApiManager: RestApiManager,
//                ordersLoader: OrdersLoaderProtocol,
//                dataLoader: DataLoaderProtocol) {
//        self.jsonDecoder = jsonDecoder
//        self.restApiManager = restApiManager
//        self.ordersLoader = ordersLoader
//        self.dataLoader = dataLoader
//    }
//    
//    deinit {
//        NotificationCenterHelper.DidSigninAction.removeObserver(self)
//        NotificationCenterHelper.DidSignoutAction.removeObserver(self)
//    }
//
//    // MARK: - Public methods
//    public func setup() {
//        NotificationCenterHelper.DidSigninAction.addObserver(self, selector: #selector(didSigninAction))
//        NotificationCenterHelper.DidSignoutAction.addObserver(self, selector: #selector(didSignoutAction))
//    }
//    @objc private func didSigninAction() { isLogined = true }
//    @objc private func didSignoutAction() { isLogined = false }
//    
//    public func setPushStatus(_ status: PushStatus) {
//        if isLogined, !isTokenSendedToServer, let fcmToken = fcmToken {
//            isTokenSendedToServer = true
//
//            let parameters = UpdatePushNotificationTokenParameters(fcmToken: fcmToken)
//            let method = AuthRestApiMethods.updatePushNotificationToken(parameters)
//            restApiManager.call(method: method) { (result: Result<String>) in
//                switch result {
//                case .success:
//                    #if DEBUG
//                    print("\n\n-------------------------------------------------------------")
//                    print("Token: \(fcmToken) , was sended to server.")
//                    print("-------------------------------------------------------------\n\n")
//                    #endif
//                case .failure:
//                    self.isTokenSendedToServer = false
//                }
//            }
//        }
//    }
//
//    public func handlePushNotification(appData: [String: Any]) {
//        print("\n\n-------------------------------------------------------------\nFIRMessagingRemoteMessage")
//        print(appData)
//        print("-------------------------------------------------------------\n\n")
//        
//        guard let code = appData[RestApiConstants.code] as? String,
//              let pushNotificationType = PushNotificationType(rawValue: code),
//              let jsonData = try? JSONSerialization.data(withJSONObject: appData, options: .prettyPrinted)
//        else { return }
//        
//        switch pushNotificationType {
//        case .orderCanceled, .orderCompleted:
//            if let object: OrderStatusChangedNotificationModel = decode(from: jsonData) {
//                ordersLoader.didChangeStatus(by: object)
//                dataLoader.loadData(completion: nil)
//            }
//        case .none:
//            break
//        }
//    }
//    
//    private func decode<T: PushNotificationModel>(from data: Data) -> T? {
//        return try? jsonDecoder.decode(T.self, from: data)
//    }
//}
//
//public enum PushStatus: Int {
//    case enable = 0
//    case disable
//}
