//
//  AlertView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 07.04.2021.
//

import UIKit

public enum RTAlertControllerDestructiveTime: Double {
    case disabled = 0
    case short = 0.5
    case medium = 1.0
    case long = 1.5
}

public final class RTAlertController: UIViewController {
    // MARK: - Variables, Constants

    /// Time when alert will be automatically dismissed. Default to .disabled
    public var destructiveTime: RTAlertControllerDestructiveTime = .disabled

    /// Position of buttons with actions
    public var actionPositionStyle: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            alertContentView?.actionPositionStyle = actionPositionStyle
        }
    }

    /// Makes this controller as hud with UIActivityIndicator
    public var showAsHud: Bool = false

    // MARK: - Private Variables
    private let visualEffectView = UIVisualEffectView()
    private var alertContentView: RTAlertContentView?
    private let activityIndicator = UIActivityIndicatorView()


    // MARK: - Internal Variables
    private var centerYCnstr = NSLayoutConstraint()
    public var closeButtonIsEnabled: Bool = false {
        didSet {
            if closeButtonIsEnabled {
                alertContentView?.enableCloseButton(with: self, action: #selector(dismissAlertSimple))
            }
        }
    }


    // MARK: - Initialization
    public convenience init(title: String? = nil, message: String? = nil, image: UIImage? = nil, actionPositionStyle: NSLayoutConstraint.Axis = .horizontal) {
        self.init()

        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        alertContentView = RTAlertContentView(title: title, message: message, image: image)

        self.actionPositionStyle = actionPositionStyle
        alertContentView?.actionPositionStyle = actionPositionStyle
    }

    public convenience init(asHud: Bool) {
        self.init()

        showAsHud = true
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        alertContentView?.actionPositionStyle = actionPositionStyle
    }


    // MARK: - ViewController LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Creating visual effect
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(visualEffectView)

        NSLayoutConstraint.activate([visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
                                     visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])

        if showAsHud {
            addActivityIndicator()
        } else {
            addContentView()
        }

        view.backgroundColor = UIColor.clear
    }

    private func addActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tintColor = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.alpha = 0
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([activityIndicator.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor),
                                     activityIndicator.centerYAnchor.constraint(equalTo: visualEffectView.centerYAnchor)])
    }

    private func addContentView() {
        guard let contentView = alertContentView else {
            assertionFailure("[RTAlertController] Error: Alert Content View is nil")
            dismissAlertSimple()
            return
        }

        // Add ContentView
        view.addSubview(contentView)
        centerYCnstr = contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        NSLayoutConstraint.activate([
                                        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        centerYCnstr,
                                        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
                                        view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 32)])

        contentView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        contentView.alpha = 0
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if showAsHud {
            activityIndicator.startAnimating()
        }

        // Custom animation
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.alertContentView?.alpha = 1
            self.alertContentView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
            self.alertContentView?.layoutIfNeeded()
            if self.showAsHud {
                self.activityIndicator.alpha = 1
            }
        }, completion: { _ in
            if self.destructiveTime != .disabled {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.destructiveTime.rawValue, execute: {
                    self.dismissAlertSimple()
                })
            }
        })
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // For the purpose of making actions without captured weak ref
        alertContentView?.removeFromSuperview()
        alertContentView = nil
    }


    // MARK: - Alert Actions

    /// Method to add action to an alert
    ///
    /// - Parameter action: Action which will be added to an alert
    @discardableResult public func addAction(_ action: RTAlertAction, toBottom: Bool = false) -> RTAlertController {
        action.addTarget(self, action: #selector(dismissAlertSimple), for: .touchUpInside)
        if toBottom {
            alertContentView?.addToBottom(action: action)
        } else {
            alertContentView?.add(action: action)
        }

        return self
    }

    /// Method to add multiple actions in one time
    ///
    /// - Parameter actions: An array of actions which will be added to an alert
    @discardableResult public func addActions(_ actions: [RTAlertAction]) -> RTAlertController {
        actions.forEach {
            addAction($0)
        }

        return self
    }

    /// Method to add content to the bottom of an alert
    ///
    /// - Parameter content: UIView subclass which will be added to an alert
    public func addContent(content: UIView) {
        alertContentView?.add(content: content)
    }

    /// Method to add content to the bottom of an alert
    ///
    /// - Parameters:
    ///   - content: UIView subclass which will be added to an alert
    ///   - size: Size of UIView. Constraints with that size would be applied to this view
    public func addContent(content: UIView, size: CGSize) {
        alertContentView?.add(content: content, size: size)
    }

    // MARK: - Presenting / Dismissing

    /// Method to present alert
    ///
    /// - Parameter viewController: UIViewController object which will present this alert
    public func present(from viewController: UIViewController) {
        viewController.present(self, animated: false, completion: nil)
    }

    /// Method to dissmiss Alert manually with completion. Also, it's automaticaly called when action triggers
    @objc public func dismissAlert(completion:(() -> Void)? = {}) {

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.alertContentView?.alpha = 0
                        self.activityIndicator.alpha = 0
                       },
                       completion: nil)

        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.visualEffectView.effect = nil
                       }) {_ in
            self.dismiss(animated: false, completion: completion)
        }
    }

    /// Method to dissmiss Alert manually. Also, it's automaticaly called when action triggers
    @objc public func dismissAlertSimple() {
        dismissAlert(completion: nil)
    }

    public func show(in controller: UIViewController? = nil) {
        if let viewController = UIApplication.keyWindow?.rootViewController {
            viewController.present(self, animated: true, completion: nil)
        }
    }
}
