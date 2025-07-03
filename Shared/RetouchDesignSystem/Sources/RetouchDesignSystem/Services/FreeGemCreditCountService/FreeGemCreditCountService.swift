//
//  FreeGemCreditCountService.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 13.02.2022.
//

import RetouchDomain

public protocol FreeGemCreditCountServiceProtocol {
    var firstOrderFreeGemsCount: Int { get }
    var needToShowFreeGemsCountAlert: Bool { get set }
}

public class FreeGemCreditCountService: FreeGemCreditCountServiceProtocol {
    // MARK: - Properties
    // Static
    private static let didShowFreeGemsCountAlertKey = "FreeGemCreditCountServiceDidShowFreeGemsCountAlertKey"
    
    // Data
    public var firstOrderFreeGemsCount: Int {
        return UserData.shared.user.freeGemCreditCount ?? 0
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
