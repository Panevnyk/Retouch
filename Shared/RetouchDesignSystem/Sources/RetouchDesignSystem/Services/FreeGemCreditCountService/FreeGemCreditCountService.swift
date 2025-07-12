import RetouchDomain
import RetouchUtils
import FactoryKit

public protocol FreeGemCreditCountServiceProtocol {
    var firstOrderFreeGemsCount: Int { get }
    var needToShowFreeGemsCountAlert: Bool { get set }
}

public class FreeGemCreditCountService: FreeGemCreditCountServiceProtocol {
    // MARK: - Properties
    @Injected(\.userDataService) private var userDataService
    
    // Static
    private static let didShowFreeGemsCountAlertKey = "FreeGemCreditCountServiceDidShowFreeGemsCountAlertKey"
    
    // Data
    public var firstOrderFreeGemsCount: Int {
        return userDataService.user.freeGemCreditCount ?? 0
    }
    public var needToShowFreeGemsCountAlert: Bool {
        get {
            return firstOrderFreeGemsCount > 0 && !didShowFreeGemsCountAlertUD
        } set {
            didShowFreeGemsCountAlertUD = !newValue
        }
    }
    
    // UD
    @UserDefaultsBacked(key: FreeGemCreditCountService.didShowFreeGemsCountAlertKey)
    private var didShowFreeGemsCountAlertUD = false
    
    // MARK: - Init
    public init() {}
}
