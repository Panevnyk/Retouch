//
//  AutoRemovePhotoService.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 28.01.2022.
//

import Foundation
import RetouchDomain

public protocol SavePhotoInfoServiceProtocol {
    var isClosed: Bool { get set }
}

public class SavePhotoInfoService: SavePhotoInfoServiceProtocol {
    private static let isClosed = "SavePhotoInfoServiceIsClosed"
    
    @UserDefaultsBacked(key: SavePhotoInfoService.isClosed)
    private var isClosedUD = false
    
    public var isClosed: Bool {
        get { isClosedUD }
        set { isClosedUD = newValue }
    }
    
    public init() {}
}
