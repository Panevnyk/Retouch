//
//  ToastHelper.swift
//  Findd
//
//  Created by Panevnyk Vlad on 8/29/18.
//  Copyright © 2018 Anton Voropaev. All rights reserved.
//

import UIKit

@MainActor
public final class ToastHelper {
    public static let shared = ToastHelper()
    
    private weak var toastView: ToastView?
    
    public func show(message: String) {
        hide()
        createToastView(message: message)
    }
    
    public func show(onView view: UIView, message: String) {
        hide()
        createToastView(onView: view, message: message)
    }
    
    public func hide() {
        if let toastView = toastView {
            toastView.hide()
        }
    }
    
    private func createToastView(message: String) {
        if let vc = UIApplication.presentationViewController {
            createToastView(onView: vc.view, message: message)
        }
    }
    
    private func createToastView(onView view: UIView, message: String) {
        let toastView = ToastView()
        toastView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastView)
        
        NSLayoutConstraint.activate([toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     view.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: 44),
                                     toastView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
                                     view.trailingAnchor.constraint(greaterThanOrEqualTo: toastView.trailingAnchor, constant: 32)])
        
        toastView.show(message: message)
        self.toastView = toastView
    }
}
