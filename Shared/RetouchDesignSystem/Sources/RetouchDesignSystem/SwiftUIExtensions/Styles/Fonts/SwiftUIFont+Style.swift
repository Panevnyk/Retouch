//
//  SwiftUIFont+Style.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 17.09.2022.
//

import SwiftUI

public extension Font {
    static var kDescriptionText: Font {
        return Font.system(size: 12, weight: .regular)
    }

    static var kDescriptionMediumText: Font {
        return Font.system(size: 12, weight: .medium)
    }

    static var kPlainText: Font {
        return Font.system(size: 14, weight: .regular)
    }

    static var kPlainBoldText: Font {
        return Font.system(size: 14, weight: .semibold)
    }

    static var kTitleText: Font {
        return Font.system(size: 15, weight: .medium)
    }

    static var kTitleBigText: Font {
        return Font.system(size: 16, weight: .medium)
    }

    static var kTitleBigBoldText: Font {
        return Font.system(size: 16, weight: .semibold)
    }

    static var kPlainBigText: Font {
        return Font.system(size: 18, weight: .regular)
    }

    static var kSectionHeaderText: Font {
        return Font.system(size: 18, weight: .semibold)
    }

    static var kBigTitleText: Font {
        return Font.system(size: 22, weight: .semibold)
    }
}
