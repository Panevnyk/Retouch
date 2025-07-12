//
//  HeaderView.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 20.01.2021.
//

import UIKit
import Combine
import RetouchDomain
import RetouchUtils
import FactoryKit

@MainActor
public protocol HeaderViewDelegate: AnyObject {
    func backAction(from view: HeaderView)
}

public protocol HeaderViewExpandableDelegate: AnyObject {
    func getFromViewController() -> UIViewController
    func getPresentableViewController() -> UIViewController
}

@objc(HeaderView)
final public class HeaderView: BaseCustomView {
    // MARK: - Properties
    @Injected(\.userDataService) private var userDataService
    
    // UI
    @IBOutlet private var xibView: UIView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var bottomContainerView: UIView!

    @IBOutlet private var actionStackView: UIStackView!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var titleLabel: UILabel!

    @IBOutlet private var expandableView: BaseTapableView!
    @IBOutlet private var expandableLabel: UILabel!
    @IBOutlet private var expandableImageView: UIImageView!

    @IBOutlet private var balanceView: BalanceView!
    @IBOutlet private var freeBadgeImage: UIImageView!

    public var isBackButtonHidden: Bool = true {
        didSet {
            backButton.isHidden = isBackButtonHidden
        }
    }

    private var isExpanded = false
    private var expandableContainerView: UIView?
    private var topExpandableContainerAnchor: NSLayoutConstraint?

    // Delegate
    public weak var balanceDelegate: BalanceViewDelegate?
    public weak var delegate: HeaderViewDelegate?
    public weak var expandableDelegate: HeaderViewExpandableDelegate?
    
    private var cancellable: [AnyCancellable] = []

    // MARK: - initialize
    override public func initialize() {
        super.initialize()

        addSelfNibUsingConstraints(bundle: Bundle.module)
        setupUI()
        bindData()
    }
}

// MARK: - Public methods
extension HeaderView {
    public func setTitle(_ text: String) {
        titleLabel.text = text
    }

    public func setTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }

    public func setBalanceColor(_ color: UIColor) {
        balanceView.setColor(color)
    }

    public func disableBalance() {
        balanceView.isUserInteractionEnabled = false
    }

    public func hideBalance() {
        balanceView.isHidden = true
        freeBadgeImage.isHidden = true
    }

    public func setExpandableTitle(_ text: String) {
        expandableLabel.text = text
    }

    public func closeExpandableView() {
        forceCloseIsExpanded()
    }

    public func hideExpandableView() {
        expandableView.isHidden = true
    }

    public func setBackgroundColor(_ backgroundColor: UIColor) {
        containerView.backgroundColor = backgroundColor
    }
}

// MARK: - UI
private extension HeaderView {
    func bindData() {
        userDataService.userDataPublisher
            .sink {
                self.balanceView.setBalance($0.user.gemCount)
            }
            .store(in: &cancellable)
    }
}

// MARK: - UI
private extension HeaderView {
    func setupUI() {
        isBackButtonHidden = true
        clipsToBounds = false
        layer.zPosition = 100

        balanceView.balanceDelegate = self
        balanceView.setBalance(userDataService.user.gemCount)

        backgroundColor = .clear
        xibView.backgroundColor = .clear

        backButton.layer.cornerRadius = 16
        backButton.layer.masksToBounds = true
        backButton.backgroundColor = .white
        let backImage = UIImage(named: "icLeftArrowPurple", in: Bundle.module, compatibleWith: nil)
        backButton.setImage(backImage, for: .normal)

        titleLabel.font = UIFont.kBigTitleText
        titleLabel.textColor = .black

        expandableView.delegate = self

        expandableLabel.font = UIFont.kTitleText
        expandableLabel.textColor = .black

        let expandableImage = UIImage(named: "icDownArrowBlack", in: Bundle.module, compatibleWith: nil)
        expandableImageView.image = expandableImage
    }
}

// MARK: - BalanceViewDelegate
extension HeaderView: BalanceViewDelegate {
    @MainActor
    public func didTapAction(from view: BalanceView) {
        balanceDelegate?.didTapAction(from: view)
    }
}

// MARK: - BaseTapableViewDelegate
extension HeaderView: BaseTapableViewDelegate {
    @MainActor
    public func didTapAction(inView view: BaseTapableView) {
        isExpanded = !isExpanded
        changeExpandable(isExpanded: isExpanded)
    }

    func forceCloseIsExpanded() {
        isExpanded = false
        changeExpandable(isExpanded: isExpanded)
    }

    func changeExpandable(isExpanded: Bool) {
        let degrees: CGFloat = isExpanded ? 180 : 0
        let transform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)

        UIView.animate(withDuration: 0.25) {
            self.expandableImageView.transform = transform
        }

        if isExpanded {
            presentExpandableViewController()
        } else {
            dismissExpandableViewController()
        }
    }

    func presentExpandableViewController() {
        guard let presentableViewController = expandableDelegate?.getPresentableViewController(),
              let fromViewController = expandableDelegate?.getFromViewController(),
              let fromView = fromViewController.view else { return }

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .kNotActivePurple
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.kSeparatorGray.cgColor
        view.layer.borderWidth = 1
        fromView.addSubview(view)

        view.leadingAnchor.constraint(equalTo: fromView.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: fromView.trailingAnchor, constant: -16).isActive = true
        topExpandableContainerAnchor = view.topAnchor.constraint(equalTo: fromView.topAnchor, constant: -fromView.frame.size.height + 100)
        topExpandableContainerAnchor?.isActive = true
        view.heightAnchor.constraint(equalTo: fromView.heightAnchor, constant: -199).isActive = true

        view.addSubviewUsingConstraints(view: presentableViewController.view)
        fromViewController.addChild(presentableViewController, onView: view)

        expandableContainerView = view

        fromView.layoutIfNeeded()

        topExpandableContainerAnchor?.constant = 100
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            fromView.layoutIfNeeded()
        }, completion: nil)
    }

    func dismissExpandableViewController() {
        guard let presentableViewController = expandableDelegate?.getPresentableViewController(),
              let fromViewController = expandableDelegate?.getFromViewController(),
              let fromView = fromViewController.view else { return }

        topExpandableContainerAnchor?.constant = -fromView.frame.size.height + 100
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            fromView.layoutIfNeeded()
        }, completion: { _ in
            presentableViewController.removeFromParentViewController()
            self.expandableContainerView?.removeFromSuperview()
            self.expandableContainerView = nil
        })
    }
}

// MARK: - Actions
private extension HeaderView {
    @IBAction func backAction(_ sender: Any) {
        delegate?.backAction(from: self)
    }
}
