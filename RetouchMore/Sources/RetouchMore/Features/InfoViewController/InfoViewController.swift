//
//  InfoViewController.swift
//  RetouchMore
//
//  Created by Vladyslav Panevnyk on 10.03.2021.
//

import UIKit
import WebKit
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

public protocol InfoCoordinatorDelegate: BaseCoordinatorDelegate {}

@objc(InfoViewController)
public class InfoViewController: UIViewController {
    // MARK: - Properties
    @Injected(\.analytics) private var analytics
    
    // UI
    @IBOutlet private var headerView: HeaderView!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var webView: WKWebView!
    
    // Data
    public var viewModel: InfoViewModelProtocol!

    // Delegates
    public weak var coordinatorDelegate: InfoCoordinatorDelegate?

    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        analytics.logScreen(viewModel.headerTitle == "Privacy Policy" ? .privacyPolicy : .termsOfUse)
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
}

// MARK: - SetupUI
private extension InfoViewController {
    func setupUI() {
        headerView.setTitle(viewModel.headerTitle)
        headerView.hideExpandableView()
        headerView.hideBalance()
        headerView.setBackgroundColor(.kBackground)
        headerView.isBackButtonHidden = false
        headerView.delegate = self
        
        if let url = viewModel.pageURL {
            webView.load(URLRequest(url: url))
        }

        textView.text = viewModel.messageText
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.textContainer.lineFragmentPadding = 0
        textView.clipsToBounds = false
    }
}

// MARK: - HeaderViewDelegate
extension InfoViewController: HeaderViewDelegate {
    public func backAction(from view: HeaderView) {
        coordinatorDelegate?.didSelectBackAction()
    }
}
