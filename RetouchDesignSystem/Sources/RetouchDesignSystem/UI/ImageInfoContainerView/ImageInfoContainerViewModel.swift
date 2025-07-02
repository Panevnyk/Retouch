//
//  ImageInfoContainerViewModel.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 24.02.2021.
//

import UIKit

public protocol ImageInfoContainerViewModelProtocol: AnyObject {
    var title: String { get set }
    var description: String { get set }
    var price: String { get set }
    var isDownloadAndShareAvailable: Bool { get set }
    var isPayed: Bool { get set }
    var idRedoAvailable: Bool { get set }
    var rating: Int? { get set }

    var isActionAvailable: Bool { get }
}

public final class ImageInfoContainerViewModel: ImageInfoContainerViewModelProtocol {
    public var title: String
    public var description: String
    public var price: String
    public var isDownloadAndShareAvailable: Bool
    public var isPayed: Bool
    public var idRedoAvailable: Bool
    public var rating: Int?

    public var isActionAvailable: Bool {
        return !isPayed || idRedoAvailable || isDownloadAndShareAvailable
    }

    public init(
        title: String,
        description: String,
        price: String,
        isDownloadAndShareAvailable: Bool,
        isPayed: Bool,
        idRedoAvailable: Bool,
        rating: Int?
    ) {
        self.title = title
        self.description = description
        self.price = price
        self.isDownloadAndShareAvailable = isDownloadAndShareAvailable
        self.isPayed = isPayed
        self.idRedoAvailable = idRedoAvailable
        self.rating = rating
    }
}
