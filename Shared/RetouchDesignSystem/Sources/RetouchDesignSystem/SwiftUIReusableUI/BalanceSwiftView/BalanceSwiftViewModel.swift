import Combine
import RetouchDomain
import RetouchUtils
import FactoryKit

@MainActor
public class BalanceSwiftViewModel: ObservableObject {
    @Injected(\.userDataService) private var userDataService
    
    @Published public var gemCount: String = ""

    private var gemCountSubscriber: AnyCancellable?

    public init() {
        self.gemCount = String(userDataService.user.gemCount)
        bindData()
    }

    private func bindData() {
        gemCountSubscriber = userDataService.userDataPublisher
            .sink(receiveValue: {
                let newValue = String($0.user.gemCount)
                if String(newValue) != self.gemCount {
                    self.gemCount = String(newValue)
                }
            })
    }
}
