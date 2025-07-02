//
//  AlertPresenter.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk  on 04.10.2023.
//

import SwiftUI
import UIKit

public enum AlertStyle {
    case dialog
    case bottomSheet
}

public enum AlertPresentationStyle {
    case overFullScreen
    case overCurrentContext
}

@MainActor
final public class AlertPresenter {
    private let presentation: AlertPresentation
    private let alertStyle: AlertStyle
    private let presentationStyle: AlertPresentationStyle
    private let additionalView: AnyView?

    public init(
        presentation: AlertPresentation,
        alertStyle: AlertStyle = .bottomSheet,
        presentationStyle: AlertPresentationStyle = .overFullScreen,
        additionalView: AnyView? = nil
    ) {
        self.presentation = presentation
        self.alertStyle = alertStyle
        self.presentationStyle = presentationStyle
        self.additionalView = additionalView
    }

    public func present(from viewController: UIViewController) {
        let view = AlertView(
            presentation: presentation,
            alertStyle: alertStyle,
            presentationStyle: presentationStyle,
            additionalView: additionalView
        )
        let hosting = UIHostingController(
            rootView: AnyView(view.navigationBarHidden(true))
        )
        hosting.modalTransitionStyle = .crossDissolve
        hosting.modalPresentationStyle = presentationStyle == .overCurrentContext ? .overCurrentContext : .overFullScreen
        hosting.view.backgroundColor = .clear

        if presentationStyle == .overCurrentContext {
            viewController.definesPresentationContext = true
        }
        viewController.present(hosting, animated: true)
    }
}
