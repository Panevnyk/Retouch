//
//  HostingViewControllerWithoutNavBar.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 11.10.2022.
//

import SwiftUI
import UIKit

open class HostingViewControllerWithoutNavBar<Content>: UIHostingController<AnyView> where Content: View {
    // MARK: - Properties
    public let rootSwiftUIView: Content

    // MARK: - Inits
    public init(rootView: Content, hidesBottomBarWhenPushed: Bool = true) {
        self.rootSwiftUIView = rootView
        super.init(rootView: AnyView(rootView.navigationBarHidden(true)))
        self.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
    }

    @objc required dynamic public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
