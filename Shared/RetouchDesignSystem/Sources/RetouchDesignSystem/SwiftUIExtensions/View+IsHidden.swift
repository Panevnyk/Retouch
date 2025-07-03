//
//  View+IsHidden.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 17.09.2022.
//

import SwiftUI

public extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: false)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = true) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
