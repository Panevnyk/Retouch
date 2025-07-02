//
//  DetailTagAlertView.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 03.06.2021.
//

import UIKit
import RetouchDomain
import RetouchDesignSystem
import FactoryKit

public enum DetailTagAlertControllerDestructiveTime: Double {
    case disabled = 0
    case short = 0.5
    case medium = 1.0
    case long = 1.5
}

@MainActor
public protocol DetailTagAlertViewControllerDelegate: AnyObject {
    func didSelectAdd(value: String?, from viewController: DetailTagAlertViewController)
}

public typealias PresentableRetouchData =
    (retouchGroup: PresentableRetouchGroup, tag: RetouchTag)

public final class DetailTagAlertViewController: BaseKeyboardObservableViewController {
    // MARK: - Variables, Constants
    @Injected(\.analytics) private var analytics
    
    // Constants
    static let centerYContainerKeyboardHide: CGFloat = 0
    static let centerYContainerKeyboardShow: CGFloat = 32

    /// Time when alert will be automatically dismissed. Default to .disabled
    public var destructiveTime: DetailTagAlertControllerDestructiveTime = .disabled

    /// Position of buttons with actions
    public var actionPositionStyle: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            alertContentView?.actionPositionStyle = actionPositionStyle
        }
    }
    
    public weak var delegate: DetailTagAlertViewControllerDelegate?

    // MARK: - Private Variables
    private let visualEffectView = UIVisualEffectView()
    private var alertContentView: DetailTagAlertContentView?
    
    private var endEditingGesture: UITapGestureRecognizer?

    // MARK: - Internal Variables
    private var centerYCnstr = NSLayoutConstraint()

    // MARK: - Initialization
    public convenience init(presentableRetouchData: PresentableRetouchData) {
        self.init()

        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        alertContentView = DetailTagAlertContentView(presentableRetouchData: presentableRetouchData)

        self.actionPositionStyle = .horizontal
        alertContentView?.actionPositionStyle = .horizontal
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

        addContentView()

        view.backgroundColor = UIColor.clear
        analytics.logScreen(.detailTagAlert)
    }
    
    @objc func viewTapAction(_ sender: Any) {
        view.endEditing(true)
    }

    private func addContentView() {
        guard let contentView = alertContentView else {
            assertionFailure("[RTAlertController] Error: Alert Content View is nil")
            dismissAlertSimple()
            return
        }

        // Add ContentView
        contentView.delegate = self
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
        
        alertContentView?.showKeyboard()

        // Custom animation
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.alertContentView?.alpha = 1
            self.alertContentView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
            self.alertContentView?.layoutIfNeeded()
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
    
    override public func keyboardHeightDidChange(_ keyboardHeight: CGFloat) {
        updateCenterYContainer(constant: -keyboardHeight / 2, animated: true)
        
        if keyboardHeight == 0 { removeEndEditingGesture() }
        else { addEndEditingGesture() }
    }

    private func updateCenterYContainer(constant: CGFloat, animated: Bool) {
        centerYCnstr.constant = constant
        if animated {
            UIView.animate(withDuration: 0.25)
                { self.view.layoutIfNeeded() }
        }
    }

    private func addEndEditingGesture() {
        endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapAction))
        view.addGestureRecognizer(endEditingGesture!)
    }
    
    private func removeEndEditingGesture() {
        if let endEditingGesture = endEditingGesture {
            view.removeGestureRecognizer(endEditingGesture)
        }
        endEditingGesture = nil
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
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.alertContentView?.alpha = 0
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
        if let viewController = UIApplication.presentationViewController {
            viewController.present(self, animated: true, completion: nil)
        }
    }
}

// MARK: - DetailTagAlertContentViewDelegate
extension DetailTagAlertViewController: DetailTagAlertContentViewDelegate {
    public func didSelectCancel(from view: DetailTagAlertContentView) {
        dismissAlertSimple()
    }
    
    public func didSelectAdd(value: String?, from view: DetailTagAlertContentView) {
        dismissAlertSimple()
        delegate?.didSelectAdd(value: value, from: self)
    }
}
