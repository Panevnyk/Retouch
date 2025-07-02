//
//  BalanceViewController.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 17.02.2021.
//

import UIKit
import Combine
import RetouchDomain
import RetouchUtils
import RetouchDesignSystem
import FactoryKit

@MainActor
public protocol BalanceCoordinatorDelegate: BaseCoordinatorDelegate {}

@MainActor
public protocol BalanceFromOrderCoordinatorDelegate: AnyObject {
    func purchasedSuccessfullyWithRequiredOrder()
}

@objc(BalanceViewController)
public final class BalanceViewController: UIViewController {
    // MARK: - Properties
    @Injected(\.analytics) private var analytics
    
    // UI
    @IBOutlet private var headerView: HeaderView!
    @IBOutlet private var yourOrderView: BalanceInfoView!
    @IBOutlet private var yourBalanceView: BalanceInfoView!
    @IBOutlet private var segmentedControl: UISegmentedControl!
    @IBOutlet private var freeBadgeImage: UIImageView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var collectionViewFlowLayout: UICollectionViewFlowLayout!

    // ViewModel
    public var viewModel: BalanceViewModelProtocol!

    // Delegates
    public weak var coordinatorDelegate: BalanceCoordinatorDelegate?
    public weak var fromOrderCoordinatorDelegate: BalanceFromOrderCoordinatorDelegate?
    
    private var cancellable: [AnyCancellable] = []

    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        analytics.logScreen(.balance)
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
}

// MARK: - SetupUI
private extension BalanceViewController {
    func setupUI() {
        view.backgroundColor = .kBackground
        
        headerView.setTitle(viewModel.getTitle())
        headerView.setBackgroundColor(.clear)
        headerView.setTitleColor(.black)
        headerView.setBalanceColor(.white)
        headerView.hideExpandableView()
        headerView.hideBalance()
        headerView.isBackButtonHidden = false
        headerView.delegate = self

        let orderAmount = viewModel.getOrderAmount()
        yourOrderView.setAmount(orderAmount)
        yourOrderView.setTopTitle("Your order:")
        yourOrderView.isHidden = orderAmount == nil

        yourBalanceView.setAmount(viewModel.getBalance())
        yourBalanceView.setTopTitle("Your balance:")
        
        segmentedControl.backgroundColor = .white
        segmentedControl.layer.borderColor = UIColor.kPurple.cgColor
        segmentedControl.selectedSegmentTintColor = .kPurple
        segmentedControl.layer.borderWidth = 1
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                   NSAttributedString.Key.font: UIFont.kPlainText]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                    NSAttributedString.Key.font: UIFont.kPlainText]
        segmentedControl.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        
        freeBadgeImage.image = UIImage(named: "icFreeBadge", in: Bundle.designSystem, compatibleWith: nil)

        collectionView.backgroundColor = .kBackground
        collectionView.register(cell: BalanceCollectionViewCell.self)
        collectionView.register(cell: SubscriptionBalanceCollectionViewCell.self)
        collectionView.register(cell: EarnBalanceCollectionViewCell.self)
        collectionView.register(TitleHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TitleHeaderView.className)
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 68)
    }

    func bindData() {
        UserData.shared.user.$gemCount
            .sink { (value) in
                self.yourBalanceView.setAmount(String(value))
            }.store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BalanceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsCount(in: section)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let balanceSectionType = viewModel.balanceSectionType(by: indexPath.section)
        switch balanceSectionType {
        case .subscription:
            let cell: SubscriptionBalanceCollectionViewCell = collectionView.dequeueReusableCellWithIndexPath(indexPath)
            return cell
        case .oneTime:
            let cell: BalanceCollectionViewCell = collectionView.dequeueReusableCellWithIndexPath(indexPath)
            cell.fill(viewModel: viewModel.oneTimeViewModel(for: indexPath.item))
            return cell
        case .getForFree:
            let cell: EarnBalanceCollectionViewCell = collectionView.dequeueReusableCellWithIndexPath(indexPath)
            cell.fill(viewModel: viewModel.earnViewModel(for: indexPath.item))
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: TitleHeaderView = collectionView.dequeueReusableSupplementaryViewWithIndexPath(
            indexPath,
            kind: UICollectionView.elementKindSectionHeader)
        let title = viewModel.getSectionTitle(by: indexPath.section)
        headerView.set(title: title)
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(for: indexPath.item, section: indexPath.section, from: self)
        analytics.logAction(viewModel.getAnalytics(for: indexPath.item, section: indexPath.section))
    }

    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BalanceViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let balanceSectionType = viewModel.balanceSectionType(by: indexPath.section)
        switch balanceSectionType {
        case .subscription:
            return sizeForSubscriptionItem
        case .oneTime:
            return sizeForOneTimeItem
        case .getForFree:
            return sizeForOneTimeItem
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let balanceSectionType = viewModel.balanceSectionType(by: section)
        switch balanceSectionType {
        case .subscription:
            return sectionInsets
        case .oneTime:
            return sectionInsets
        case .getForFree:
            return sectionInsets
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }

    private var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
    }
    
    private var minimumInteritemSpacing: CGFloat {
        return 16
    }
    
    private var sizeForSubscriptionItem: CGSize {
        let paddingSpace = sectionInsets.left * 2
        let availableWidth = view.frame.width - paddingSpace
        return CGSize(width: availableWidth, height: 60)
    }

    private var sizeForOneTimeItem: CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 100)
    }
}

// MARK: - HeaderViewDelegate
extension BalanceViewController: HeaderViewDelegate {
    public func backAction(from view: HeaderView) {
        coordinatorDelegate?.didSelectBackAction()
    }
}

// MARK: - BalanceViewModelDelegate
extension BalanceViewController: BalanceViewModelDelegate {
    public func reloadData() {
        collectionView.reloadData()
    }

    public func purchasedSuccessfully() {
        let isOrderRequired = viewModel.getOrderAmount() != nil
        guard isOrderRequired else { return }

        if viewModel.isEnoughCreditsForOrder() {
            fromOrderCoordinatorDelegate?.purchasedSuccessfullyWithRequiredOrder()
        }
    }
}

// MARK: - Actions
private extension BalanceViewController {
    @IBAction func getCreditsTypeValueChanged(_ sender: Any) {
        viewModel.setGetCreditsType(index: segmentedControl.selectedSegmentIndex)
        reloadData()
    }
}
