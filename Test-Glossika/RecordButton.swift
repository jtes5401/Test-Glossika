//
//  PlayButton.swift
//  Test-Glossika
//
//  Created by Wei Kuo on 2021/3/29.
//

import UIKit


class RecordButton: UIButton {
    var isRecord = false {
        didSet {
            showStyle()
        }
    }
    
    func showStyle() {
        self.layer.cornerRadius = self.frame.size.width / 2

        if isRecord {
            self.layer.borderWidth = 5.0
            self.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            self.layer.borderWidth = 2.0
            self.layer.borderColor = UIColor.white.cgColor
        }

        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        showStyle()
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(rect)
            context.setFillColor(UIColor.red.cgColor)

            if isRecord {
                let subRect = rect.inset(by: .init(top: 20, left: 20, bottom: 20, right: 20))
                let path = CGPath.init(roundedRect: subRect, cornerWidth: 5.0, cornerHeight: 5.0, transform: nil)
                context.addPath(path)
                context.fillPath()
            } else {
                let subRect = rect.inset(by: .init(top: 10, left: 10, bottom: 10, right: 10))
                context.fillEllipse(in: subRect)
            }

        }
    }
    
    
}


class PlayButton: UIButton {
    var isOn = false {
        didSet {
            showStyle()
        }
    }
    
    func showStyle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderWidth = 5.0

        if isOn {
            self.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            self.layer.borderColor = UIColor.white.cgColor
        }

        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        showStyle()
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(rect)
            context.setFillColor(UIColor.red.cgColor)
            let subRect = rect.inset(by: .init(top: 20, left: 20, bottom: 20, right: 20))

            if isOn {
                let r1 = CGRect.init(x: subRect.minX, y: subRect.minY, width: subRect.width * 0.33, height: subRect.height)
                let r2 = CGRect.init(x: subRect.minX + (subRect.width * 0.66), y: subRect.minY, width: subRect.width * 0.33, height: subRect.height)
                context.fill([r1,r2])
            } else {
                context.move(to: subRect.origin)
                context.addLine(to: .init(x: subRect.minX, y: subRect.maxY))
                context.addLine(to: .init(x: subRect.maxX, y: subRect.midY))
                context.addLine(to: subRect.origin)
                context.fillPath()
            }

        }
    }
    
    
}
