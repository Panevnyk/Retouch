////
////  LocalRatingService.swift
////  RetouchDesignSystem
////
////  Created by Panevnyk Vlad on 25.08.2021.
////
//
//import UIKit
//import RetouchNetworking
//import FactoryKit
//
//public protocol LocalFeedbackServiceProtocol {
//    func requestLocalReview(for order: Order, completion: ((_ newOrder: Order?) -> Void)?)
//}
//
//public class LocalFeedbackService: LocalFeedbackServiceProtocol {
//    // MARK: - Properties
//    @Injected(\.analytics) private var analytics
//    
//    private let ordersLoader: OrdersLoaderProtocol
//    
//    // MARK: - Inits
//    public init(ordersLoader: OrdersLoaderProtocol) {
//        self.ordersLoader = ordersLoader
//    }
//    
//    // MARK: - Public methods
//    public func requestLocalReview(for order: Order, completion: ((_ newOrder: Order?) -> Void)?) {
//        if let rating = order.rating {
//            showChangeLocalReview(currentReview: rating, order: order, completion: completion)
//        } else {
//            showNewLocalReview(for: order, completion: completion)
//        }
//    }
//    
//    private func showNewLocalReview(for order: Order, completion: ((_ newOrder: Order?) -> Void)?) {
//        analytics.logScreen(.ratingAlert)
//
//        let ratingView = RatingView()
//        let send = RTAlertAction(title: "Send", style: .default, action: {
//            self.sendRating(ratingView.selectedRating, order: order, completion: completion)
//        })
//        send.isEnabled = false
//        ratingView.didSelectRating = { _ in send.isEnabled = true }
//        let alert = RTAlertController(title: "Do you like our designers work?", message: nil, image: nil)
//        alert.addContent(content: ratingView, size: CGSize(width: 192, height: 32))
//        alert.addActions([send])
//        alert.show()
//    }
//
//    private func showChangeLocalReview(currentReview: Int, order: Order, completion: ((_ newOrder: Order?) -> Void)?) {
//        analytics.logScreen(.ratingAlert)
//
//        let ratingView = RatingView()
//        ratingView.setRating(currentReview)
//        let cancel = RTAlertAction(title: "Cancel", style: .cancel, action: {
//            self.didCancelRatingAlert(completion: completion)
//            completion?(nil)
//        })
//        let send = RTAlertAction(title: "Send", style: .default, action: {
//            self.sendRating(ratingView.selectedRating, order: order, completion: completion)
//        })
//        let alert = RTAlertController(title: "Do you want to change your feedback?", message: nil, image: nil)
//        alert.addContent(content: ratingView, size: CGSize(width: 192, height: 32))
//        alert.addActions([cancel, send])
//        alert.show()
//    }
//}
//// MARK: - Actions
//private extension LocalFeedbackService {
//    func didCancelRatingAlert(completion: ((_ newOrder: Order?) -> Void)?) {
//        analytics.logAction(.cancelRating)
//        completion?(nil)
//    }
//
//    func sendRating(_ rating: Int, order: Order, completion: ((_ newOrder: Order?) -> Void)?) {
//        analytics.logAction(.sendRating)
//
//        let parameters = OrderRatingParameters(id: order.id, rating: rating)
//        ordersLoader.sendRating(orderRatingParameters: parameters) { (result: Result<Order>) in
//            switch result {
//            case .success(let order):
//                completion?(order)
//            case .failure(let error):
//                RetouchNotificationBanner.showBanner(error)
//                completion?(nil)
//            }
//        }
//    }
//}
//
