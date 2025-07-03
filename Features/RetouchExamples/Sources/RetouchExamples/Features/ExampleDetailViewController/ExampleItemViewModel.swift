//
//  ExampleItemViewModel.swift
//  RetouchExamples
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import RetouchUtils
import RetouchDesignSystem

public protocol ExampleItemViewModelProtocol {
    var title: String { get set }
    var description: String { get set }
    var price: String { get set }
    var isDownloadAndShareAvailable: Bool { get set }
    var isPayed: Bool { get set }
    var idRedoAvailable: Bool { get set }
    var rating: Int? { get set }
    var isNeedToShowRating: Bool { get set }

    var imageAfter: String { get set }
    var imageBefore: String { get set }
}

public extension ExampleItemViewModelProtocol {
    func makeImageInfoContainerViewModel() -> ImageInfoContainerViewModelProtocol {
        return ImageInfoContainerViewModel(
            title: title,
            description: description,
            price: price,
            isDownloadAndShareAvailable: isDownloadAndShareAvailable,
            isPayed: isPayed,
            idRedoAvailable: idRedoAvailable,
            rating: rating)
    }
}

public final class ExampleItemViewModel: ExampleItemViewModelProtocol {
    public var title: String
    public var description: String
    public var price: String
    public var isDownloadAndShareAvailable: Bool
    public var isPayed: Bool
    public var idRedoAvailable: Bool
    public var rating: Int?
    public var isNeedToShowRating: Bool

    public var imageAfter: String
    public var imageBefore: String

    public init(
        title: String,
        description: String,
        imageAfter: String,
        imageBefore: String,
        price: String = "",
        isDownloadAndShareAvailable: Bool = false,
        isPayed: Bool = true,
        idRedoAvailable: Bool = false,
        rating: Int? = nil,
        isNeedToShowRating: Bool = false
    ) {
        self.title = title
        self.description = description
        self.price = price
        self.isDownloadAndShareAvailable = isDownloadAndShareAvailable
        self.isPayed = isPayed
        self.idRedoAvailable = idRedoAvailable
        self.rating = rating
        self.isNeedToShowRating = isNeedToShowRating

        self.imageAfter = Constants.exampleBaseURL + imageAfter
        self.imageBefore = Constants.exampleBaseURL + imageBefore
    }
}
