//
//  AlertViewModel.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk  on 04.10.2023.
//

import Combine
import SwiftUI
import UIKit

public protocol AlertPresentation {
    var icon: UIImage? { get }
    var title: String? { get }
    var subtitle: String? { get }
    var cta: String? { get }
    var action: (() -> Void)? { get }
    var secondCta: String? { get }
    var secondAction: (() -> Void)? { get }
}

final public class AlertViewModel: AlertPresentation {
    public var icon: UIImage?
    public var title: String?
    public var subtitle: String?
    public var cta: String?
    public var action: (() -> Void)?
    public var secondCta: String?
    public var secondAction: (() -> Void)?

    public init(
        icon: UIImage? = nil,
        title: String?,
        subtitle: String?,
        cta: String?,
        action: (() -> Void)?,
        secondCta: String? = nil,
        secondAction: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.cta = cta
        self.action = action
        self.secondCta = secondCta
        self.secondAction = secondAction
    }
}

