//
//  BalanceSwiftViewModel.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 17.09.2022.
//

import Combine
import RetouchDomain

@MainActor
public class BalanceSwiftViewModel: ObservableObject {
    @Published public var gemCount: String

    private var gemCountSubscriber: AnyCancellable?

    public init() {
        self.gemCount = String(UserData.shared.user.gemCount)
        bindData()
    }

    private func bindData() {
        gemCountSubscriber = UserData.shared.user.$gemCount
            .sink(receiveValue: {
                let newValue = String($0)
                if String(newValue) != self.gemCount {
                    self.gemCount = String(newValue)
                }
            })
    }
}
