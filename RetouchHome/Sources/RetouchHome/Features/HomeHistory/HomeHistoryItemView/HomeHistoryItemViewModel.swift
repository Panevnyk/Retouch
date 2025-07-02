//
//  HomeHistoryItemViewModel.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 16.02.2021.
//

import SwiftUI
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

public struct HomeHistoryItemViewModel {
    @Injected(\.imageLoader) var imageLoader
    public var beforeImage: String?
    public var afterImage: String?
    public var imageToShow: String?
    public var isPayed: Bool
    public var isNew: Bool
    public var status: OrderStatus
    
    public var isStatusHidden: Bool {
        status == .completed
    }
    
    public var statusTitle: String {
        status.title
    }
    
    public var statusBackgroundColor: Color {
        status.backgroundColor
    }

    public init(beforeImage: String?,
                afterImage: String?,
                isPayed: Bool,
                isNew: Bool,
                status: OrderStatus
    ) {
        self.beforeImage = beforeImage
        self.afterImage = afterImage
        self.imageToShow = status == .completed ? afterImage : beforeImage
        self.isPayed = isPayed
        self.isNew = isNew
        self.status = status
    }
}

extension OrderStatus {
    var title: String {
        switch self {
        case .waiting: return "Waiting"
        case .canceled: return "Canceled"
        case .confirmed: return "Confirmed"
        case .waitingForReview, .inReview, .redoByLeadDesigner: return "Waiting"
        case .completed: return "Completed"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .waiting: return Color.kBlue
        case .canceled: return Color.kRed
        case .confirmed: return Color.kGreen
        case .waitingForReview, .inReview, .redoByLeadDesigner: return Color.kBlue
        case .completed: return Color.kBlue
        }
    }
}
