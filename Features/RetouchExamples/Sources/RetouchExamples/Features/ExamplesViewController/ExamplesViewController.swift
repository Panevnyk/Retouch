//
//  ExamplesViewController.swift
//  RetouchExamples
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

public protocol ExamplesCoordinatorDelegate: BaseBalanceCoordinatorDelegate {
    func didSelectExampleItem(_ viewModel: ExampleItemViewModelProtocol, from viewController: ExamplesViewController)
}

@objc(ExamplesViewController)
public class ExamplesViewController: UIViewController {
    // MARK: - Properties
    @Injected(\.analytics) private var analytics
    
    // UI
    @IBOutlet private var headerView: HeaderView!
    @IBOutlet private var tableView: UITableView!

    // ViewModel
    public var viewModel: ExamplesViewModelProtocol!

    // Delegates
    public weak var coordinatorDelegate: ExamplesCoordinatorDelegate?

    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        analytics.logScreen(.examples)
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    // MARK: - Public methods
    public func setupTabBar() {
        tabBarItem.image = MainTab.examples.image
        tabBarItem.selectedImage = MainTab.examples.selectedImage
        tabBarItem.title = "Examples"
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ExamplesViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount(in: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExamplesTableViewCell = tableView.dequeueReusableCellWithIndexPath(indexPath)
        let itemViewModel = viewModel.examplesItem(for: indexPath.row)
        cell.fill(viewModel: itemViewModel)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewModel = viewModel.examplesItem(for: indexPath.row)
        coordinatorDelegate?.didSelectExampleItem(itemViewModel, from: self)
    }

    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

// MARK: - SetupUI
private extension ExamplesViewController {
    func setupUI() {
        view.backgroundColor = .kBackground
        tableView.backgroundColor = .kBackground

        headerView.setTitle("Our designers works")
        headerView.hideExpandableView()
        headerView.setBackgroundColor(.kBackground)
        headerView.balanceDelegate = self

        tableView.register(cell: ExamplesTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}

// MARK: - BalanceViewDelegate
extension ExamplesViewController: BalanceViewDelegate {
    public func didTapAction(from view: BalanceView) {
        coordinatorDelegate?.didSelectBalanceAction()
    }
}
