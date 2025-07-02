//
//  InfoViewModel.swift
//  RetouchMore
//
//  Created by Vladyslav Panevnyk on 10.03.2021.
//

import UIKit

public protocol InfoViewModelProtocol: Sendable {
    var headerTitle: String { get }
    var messageText: String { get }
    var pageURL: URL? { get }
}

public final class InfoViewModel: InfoViewModelProtocol, Sendable {
    public let headerTitle: String
    public let messageText: String
    public let pageURL: URL?

    public init(headerTitle: String, messageText: String, pageURL: URL?) {
        self.headerTitle = headerTitle
        self.messageText = messageText
        self.pageURL = pageURL
    }
}
