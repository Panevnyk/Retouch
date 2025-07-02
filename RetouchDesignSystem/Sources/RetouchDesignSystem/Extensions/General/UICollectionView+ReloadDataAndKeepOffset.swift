//
//  UICollectionView+ReloadDataAndKeepOffset.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import UIKit

public extension UICollectionView {
    func reloadDataAndKeepOffset() {
        setContentOffset(contentOffset, animated: false)
        let beforeContentOffset = contentOffset
        reloadData()
        layoutIfNeeded()
        setContentOffset(beforeContentOffset, animated: false)
    }
}
