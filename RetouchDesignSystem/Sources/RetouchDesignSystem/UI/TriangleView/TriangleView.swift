//
//  TriangleView.swift
//  RetouchDesignSystem
//
//  Created by Panevnyk Vlad on 03.06.2021.
//

import UIKit

public class TriangleView : UIView {
    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        context.closePath()

        context.setFillColor(UIColor.kPurpleAlpha10.cgColor)
        context.fillPath()
    }
}
