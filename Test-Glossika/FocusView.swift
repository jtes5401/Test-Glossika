//
//  FocusView.swift
//  Test-Glossika
//
//  Created by Wei Kuo on 2021/3/29.
//

import UIKit

class FocusView: UIView {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(rect)
            
            context.setStrokeColor(UIColor.yellow.cgColor)
            
            // Top left
            context.move(to: .zero)
            context.addLine(to: .init(x: 30, y: 0))
            
            context.move(to: .zero)
            context.addLine(to: .init(x: 0, y: 30))
            
            // Top right
            context.move(to: .init(x: rect.maxX, y: 0))
            context.addLine(to: .init(x: rect.maxX-30, y: 0))
            
            context.move(to: .init(x: rect.maxX, y: 0))
            context.addLine(to: .init(x: rect.maxX, y: 30))

            // Bottom left
            context.move(to: .init(x: 0, y: rect.maxY))
            context.addLine(to: .init(x: 0, y: rect.maxY-30))
            
            context.move(to: .init(x: 0, y: rect.maxY))
            context.addLine(to: .init(x: 30, y: rect.maxY))
            
            // Bottom right
            context.move(to: .init(x: rect.maxX, y: rect.maxY))
            context.addLine(to: .init(x: rect.maxX, y: rect.maxY-30))
            
            context.move(to: .init(x: rect.maxX, y: rect.maxY))
            context.addLine(to: .init(x: rect.maxX-30, y: rect.maxY))
            context.setLineWidth(10)
            context.strokePath()
            
        }
    }
}
