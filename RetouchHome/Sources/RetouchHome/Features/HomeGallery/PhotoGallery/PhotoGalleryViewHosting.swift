//
//  PhotoGalleryViewHosting.swift
//  RetouchHome
//
//  Created by Vladyslav Panevnyk on 18.10.2022.
//

import UIKit
import SwiftUI
import RetouchUtils
import RetouchDesignSystem

public class PhotoGalleryViewHosting: HostingViewControllerWithoutNavBar<PhotoGalleryView> {
    public func didSelectOrder() {
        rootSwiftUIView.didSelectOrder()
    }
}
