//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Seokhwan Moon on 15/10/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

// Create new CocoaTouch Class file since View (UIKit) is a CocoaTouch Class

import UIKit

class PlayingCardView: UIView {

    // Note that view without draw function is very common since actual drawing is usually done in subviews
    override func draw(_ rect: CGRect) {
//        // context will never be returned as nil
//        if let context = UIGraphicsGetCurrentContext() {
//            // Angle is in radian
//            // 0 is off to the right (positive x-axis)
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            UIColor.red.setStroke()
//            context.strokePath()
//            // fill is not drawn since above stroke consumes the path (need to redefine another path)
//            context.fillPath()
//        }
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        path.lineWidth = 5.0
        UIColor.green.setFill()
        UIColor.red.setStroke()
        path.stroke()
        // path still exists (not consumed)
        path.fill()
        
        // Note when the screen rotate, circle becomes oval (when the screen rotated, views are stretched to fill the screen
        // check Content Mode in inspector view
    }

}
