//
//  UIView+Border.swift
//  Sapnin
//
//  Created by Muhammad Burhan on 13/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func drawBorder(withNumberOfDots : Int){
        
        if withNumberOfDots == 0{
            return
        }
        
        if self.layer.sublayers != nil{
            for l in self.layer.sublayers!{
                if l is CAShapeLayer{
                    l.removeFromSuperlayer()
                }
            }
        }
        
        
        var gapSize: CGFloat = 0.2
        
        if withNumberOfDots == 1{
            gapSize = 0
        }
        
        let segmentAngleSize: CGFloat = (2.0 * .pi - CGFloat(withNumberOfDots) * gapSize) / CGFloat(withNumberOfDots)
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        let radius: CGFloat = self.frame.width / 2
        let lineWidth: CGFloat = 2
        let strokeColor = UIColor(red:255/255.0,  green:46/255.0,  blue:135/255.0, alpha:1).cgColor
        
        for i in 0 ..< withNumberOfDots {
            let start = CGFloat(i) * (segmentAngleSize + gapSize) - CGFloat(.pi / 2.0)
            let end = start + segmentAngleSize
            let segmentPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
            
            let arcLayer = CAShapeLayer()
            arcLayer.path = segmentPath.cgPath
            arcLayer.fillColor = UIColor.clear.cgColor
            arcLayer.strokeColor = strokeColor
            
            arcLayer.lineWidth = lineWidth
            
            self.layer.addSublayer(arcLayer)
        }
    }
    
}
