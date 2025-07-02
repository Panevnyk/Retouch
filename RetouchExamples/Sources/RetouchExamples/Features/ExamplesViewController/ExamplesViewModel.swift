//
//  ExamplesViewModel.swift
//  RetouchExamples
//
//  Created by Vladyslav Panevnyk on 13.02.2021.
//

import RetouchUtils
import RetouchDesignSystem
public protocol ExamplesViewModelProtocol {
    func itemsCount(in section: Int) -> Int
    func examplesItem(for item: Int) -> ExampleItemViewModelProtocol
}

public final class ExamplesViewModel: ExamplesViewModelProtocol {
    // MARK: - Properties
    private var examplesItems: [ExampleItemViewModelProtocol] = []

    // MARK: - Init
    public init() {
        makeExamplesItems()
    }
}

// MARK: - Public methods
extension ExamplesViewModel {
    public func itemsCount(in section: Int) -> Int {
        return examplesItems.count
    }

    public func examplesItem(for item: Int) -> ExampleItemViewModelProtocol {
        return examplesItems[item]
    }
}

// MARK: - Factory methods
private extension ExamplesViewModel {
    func makeExamplesItems() {
        examplesItems = [
            ExampleItemViewModel(title: "Body", description: "Slimmer waist, hips size, remove stretch marks, remove cellulite, legs width", imageAfter: "example0After.jpg", imageBefore: "example0Before.jpg"),
            
            ExampleItemViewModel(title: "Body", description: "Breast size", imageAfter: "example1After.jpg", imageBefore: "example1Before.jpg"),
            
            ExampleItemViewModel(title: "Face", description: "Remove pimples, smooth the skin", imageAfter: "example2After.jpg", imageBefore: "example2Before.png"),
            
            ExampleItemViewModel(title: "Body", description: "Add abs (six-pack abs)", imageAfter: "example3After.jpg", imageBefore: "example3Before.jpg"),
            
            ExampleItemViewModel(title: "Photo", description: "Remove people-objects (change suitcase to umbrella), put woman in the center", imageAfter: "example4After.jpg", imageBefore: "example4Before.jpg"),
            
            ExampleItemViewModel(title: "Body", description: "Slimmer waist, hips size, remove fat folds, arms width, legs width", imageAfter: "example5After.jpg", imageBefore: "example5Before.jpg"),

            ExampleItemViewModel(title: "Photo", description: "Color corection, change sky, align the horizon, individual retouch", imageAfter: "example6After.jpg", imageBefore: "example6Before.jpg")
        ]
    }
}
