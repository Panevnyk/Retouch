//
//  Triangle.swift
//  RetouchDesignSystem
//
//  Created by Vladyslav Panevnyk on 21.10.2022.
//

import SwiftUI

public struct Triangle: Shape {
    public init() {}
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        return path
    }
}
