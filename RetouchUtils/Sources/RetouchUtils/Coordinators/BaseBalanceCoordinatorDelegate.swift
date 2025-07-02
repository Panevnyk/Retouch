//
//  BaseBalanceCoordinatorDelegate.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 17.02.2021.
//

@MainActor
public protocol BaseBalanceCoordinatorDelegate: AnyObject {
    func didSelectBalanceAction()
}
