//
//  PhotoGalleryViewModel+OrderAlert.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 12.02.2023.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem

// MARK: - Order alerts
extension PhotoGalleryViewModel {
    func makeFreeOrderAlert(diamondsPrice: String, freeOrder: (() -> Void)?) {
        analytics.logAction(.showFreeOrderAlert)
        let order = RTAlertAction(title: "Free order",
                                  style: .default,
                                  action: { freeOrder?() })
        let cancel = RTAlertAction(title: "Cancel",
                                   style: .cancel)
        let img = UIImage(named: "icFirstOrderForFree", in: Bundle.designSystem, compatibleWith: nil)
        let alert = RTAlertController(title: "Make free order",
                                      message: "Your first order is available for free. Send the photo to our designer and enjoy the result.",
                                      image: img,
                                      actionPositionStyle: .horizontal)
        alert.addActions([cancel, order])
        alert.show()
    }
    
    func makeOutOfFreeOrderAlert(diamondsPrice: String, outOfFreeOrder: (() -> Void)?) {
        analytics.logAction(.showOutOfFreeOrderAlert)
        let order = RTAlertAction(title: "Order",
                                  style: .default,
                                  action: { outOfFreeOrder?() })
        let cancel = RTAlertAction(title: "Go back",
                                   style: .cancel)
        let img = UIImage(named: "icFirstOrderForFree", in: Bundle.designSystem, compatibleWith: nil)
        let alert = RTAlertController(title: "Your order is out of free",
                                      message: "You chose tags for more than \(diamondsPrice) diamonds. It's out of our free bonuses. You can make an order and pay for extra diamonds. Or go back and choose less amount of tags.",
                                      image: img,
                                      actionPositionStyle: .horizontal)
        alert.addActions([cancel, order])
        alert.show()
    }
    
    func makeOrderAlert(success: (() -> Void)?) {
        analytics.logAction(.showOrderAlert)
        let cancel = RTAlertAction(title: "Cancel", style: .cancel)
        let order = RTAlertAction(title: "Order", style: .default, action: { success?() })
        let img = UIImage(named: "icDoYouWannaOrder", in: Bundle.designSystem, compatibleWith: nil)
        let alert = RTAlertController(title: "Make order",
                                      message: "Our designers will do best to provide you awesome result",
                                      image: img)
        alert.addActions([cancel, order])
        alert.show()
    }
    
    func makeNotEnoughGemsOrderAlert(usdPrice: String, fastOrder: (() -> Void)?, goToBalance: (() -> Void)?) {
        analytics.logAction(.showFastOrderAlert)
        let order = RTAlertAction(title: "Order for \(usdPrice)",
                                  style: .default,
                                  action: { fastOrder?() })
        let goToBalance = RTAlertAction(title: "Buy more gems and get bonuses",
                                        style: .cancel,
                                        action: { goToBalance?() })
        let cancel = RTAlertAction(title: "Cancel",
                                   style: .cancel)
        let img = UIImage(named: "icDoYouWannaOrder", in: Bundle.designSystem, compatibleWith: nil)
        let alert = RTAlertController(title: "Make order",
                                      message: "Our designers will do best to provide you awesome result",
                                      image: img,
                                      actionPositionStyle: .vertical)
        alert.addActions([order, goToBalance, cancel])
        alert.show()
    }
}

