//
//  BaseKeyboardObservableViewController.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 11.02.2021.
//

import UIKit

open class BaseKeyboardObservableViewController: UIViewController {
    // MARK - Life Cycle
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_ :)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    open func keyboardHeightDidChange(_ keyboardHeight: CGFloat) {}
}

// MARK: - Keyboard movements
extension BaseKeyboardObservableViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }

        keyboardHeightDidChange(keyboardFrame.height)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardHeightDidChange(0)
    }
}
