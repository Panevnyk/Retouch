//
//  DetailAnimable.swift
//  Retouch
//
//  Created by Panevnyk Vlad on 3/15/20.
//

import UIKit

public protocol DetailAnimable {}

extension DetailAnimable where Self: UIView {
    @MainActor public func showView() {
        showView(completition: nil)
    }
    
    @MainActor public func showView(completition: (() -> Void)?) {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (_) in
            if let completition = completition {
                completition()
            }
        })
    }
    
    @MainActor public func hideView() {
        hideView(completition: nil)
    }
    
    @MainActor public func hideView(completition: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
//            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { (_) in
            self.transform = CGAffineTransform.identity
            if let completition = completition {
                completition()
            }
        })
    }
}
