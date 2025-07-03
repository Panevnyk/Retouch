//
//  BaseCoordinatorDelegate.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 18.11.2020.
//

@MainActor
public protocol BaseCoordinatorDelegate: AnyObject {
    func didSelectBackAction()
}
