import SwiftUI
import Combine
import RetouchDomain
import RetouchDesignSystem
import FactoryKit

struct TutorialImages: Hashable, Sendable {
    let imageView: String
    let bgImageView: String
}

@MainActor
public protocol StartingTutorialViewCoordinatorDelegate: UseAgreementsDelegate {
    func didSelectUseApp()
}

@MainActor
public class StartingTutorialViewModel: ObservableObject {
    // MARK: - Properties
    // Delegates
    @Injected(\.analytics) var analytics
    
    private(set) var coordinatorDelegate: StartingTutorialViewCoordinatorDelegate?
    
    // Data
    let tutorialImagesArray: [TutorialImages]
    
    // Combine
    @Published var headerText: String = "Tutorial"
    @Published var skipText: String = "SKIP"
    @Published var nextText: String = "NEXT"
    
    @Published var selectedItem: Int = 0
    
    private lazy var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Inits
    public init(
        coordinatorDelegate: StartingTutorialViewCoordinatorDelegate?
    ) {
        self.coordinatorDelegate = coordinatorDelegate
        self.tutorialImagesArray = [
            TutorialImages(imageView: "tutorialImage1", bgImageView: "tutorialBGImage1"),
            TutorialImages(imageView: "tutorialImage2", bgImageView: "tutorialBGImage2"),
            TutorialImages(imageView: "tutorialImage3", bgImageView: "tutorialBGImage3")
        ]
        
        bindData()
    }
    
    // MARK: Bind
    func bindData() {
        $selectedItem
            .sink { value in
                self.headerText = "Tutorial \(value + 1)/\(self.tutorialImagesArray.count)"
                self.nextText = self.isLastItem(value) ? "START" : "NEXT"
            }
            .store(in: &subscriptions)
    }
    
    func isLastItem(_ item: Int) -> Bool {
        return item >= tutorialImagesArray.count - 1
    }

    // MARK: - Actions
    func onAppear() {
        StartingTutorialView.isShowen = true
        analytics.logScreen(.startingTutorial)
    }
    
    func skipAction() {
        coordinatorDelegate?.didSelectUseApp()
        analytics.logAction(.skipStartingTutorial)
    }
    
    func nextAction() {
        if isLastItem(selectedItem) {
            coordinatorDelegate?.didSelectUseApp()
            analytics.logAction(.signInStartingTutorial)
        } else {
            selectedItem += 1
            analytics.logAction(.nextStartingTutorial)
        }
    }
}
