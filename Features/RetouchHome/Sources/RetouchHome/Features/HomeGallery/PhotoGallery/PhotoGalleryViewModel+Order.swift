//
//  PhotoGalleryViewModel+Order.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 12.02.2023.
//

import UIKit
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem
import RetouchNetworking

// MARK: - Create order
extension PhotoGalleryViewModel {
    public func createOrderRequest() async throws -> Order {
        guard let image else { throw NSError(domain: "Photo galler no image provided", code: 404) }
        
        let createOrderModel = CreateOrderModel(
            beforeImage: image,
            selectedRetouchGroups: self.retouchGroups
                .filter { $0.isSelected }
                .map {
                    SelectedRetouchGroupParameters(
                        retouchGroupId: $0.id,
                        selectedRetouchTags: $0.selectedRetouchTags.map {
                            SelectedRetouchTagParameters(retouchTagId: $0.id,
                                                         retouchTagTitle: $0.title,
                                                         retouchTagPrice: $0.price,
                                                         retouchTagDescription: $0.tagDescription)
                        },
                        retouchGroupTitle: $0.title,
                        descriptionForDesigner: $0.descriptionForDesigner
                    )
                },
            price: self.getOrderAmount(),
            isFreeOrder: isFirstOrderForFreeAvailabel() && !isFirstOrderForFreeOutOfFreeGemCount()
        )
        
        let order = try await ordersLoader.createOrder(createOrderModel: createOrderModel)
        return order
    }
}

// MARK: - Purchase
extension PhotoGalleryViewModel {
    func makePurchase() {
        guard let iapProductResponse = getMinIAPProductResponse(gemsCount: getOrderAmount()) else { return }
        iapService.purchase(productResponse: iapProductResponse) { [weak self] isSuccessfully in
            guard let self = self else { return }
            self.isPurchaseBlurViewHidden = true
            if isSuccessfully {
                self.createOrder()
            }
        }
    }
}

// MARK: - Order logic
extension PhotoGalleryViewModel {
    func didSelectFreeOrStandartOrder() {
        if isFirstOrderForFreeAvailabel() {
            didSelectFreeOrder()
        } else {
            didSelectOrder()
        }
    }
    
    func didSelectFreeOrder() {
        if isFirstOrderForFreeOutOfFreeGemCount() {
            makeOutOfFreeOrderAlert(diamondsPrice: getUserFreeGemCreditCount()) { [weak self] in
                self?.analytics.logAction(.makeOutOfFreeFastOrder)
                self?.fastOrder()
            }
        } else {
            makeFreeOrderAlert(diamondsPrice: getUserFreeGemCreditCount()) { [weak self] in
                self?.analytics.logAction(.makeFreeOrder)
                self?.createOrder()
            }
        }
    }
    
    public func didSelectOrder() {
        if isEnoughGemsForOrder {
            makeOrderAlert { [weak self] in
                self?.analytics.logAction(.makeOrder)
                self?.createOrder()
            }
        } else {
            if let usdPrice = getOrderPriceUSD() {
                if isCountainOrderHistory {
                    makeNotEnoughGemsOrderAlert(
                        usdPrice: usdPrice,
                        fastOrder: { [weak self] in self?.fastOrder() },
                        goToBalance: { [weak self] in self?.goToBalance() })
                } else {
                    fastOrder()
                }
            } else {
                goToBalance()
            }
        }
    }
    
    fileprivate func fastOrder() {
        analytics.logAction(.makeFastOrder)
        isPurchaseBlurViewHidden = false
        makePurchase()
    }
    
    fileprivate func goToBalance() {
        analytics.logAction(.showBalanceFromOrder)
        coordinatorDelegate?.didSelectOrderNotEnoughGems(
            orderAmount: getOrderAmount()
        )
    }
    
    fileprivate func createOrder() {
        Task {
            ActivityIndicatorHelper.shared.show()
            do  {
                let order = try await createOrderRequest()
                ActivityIndicatorHelper.shared.hide()
                coordinatorDelegate?.didSelectOrder(order)
            } catch {
                ActivityIndicatorHelper.shared.hide()
                notificationBanner.showBanner(error)
            }
        }
    }
}

