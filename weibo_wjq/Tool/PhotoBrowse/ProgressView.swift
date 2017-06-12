//
//  ProgressView.swift
//  weibo_wjq
//
//  Created by landixing on 2017/6/12.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    var progress : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
  
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 8
        let startAngle = CGFloat(-Double.pi/2)
        let endAngle = CGFloat(Double.pi * 2) * progress + startAngle
   
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        bezierPath.addLine(to: center)
        bezierPath.close()
        
        
        UIColor(white: 1.0, alpha: 0.2).setFill()
        bezierPath.fill()
        
        let closePath = UIBezierPath(arcCenter: center, radius: radius + 5, startAngle: startAngle, endAngle: CGFloat(Double.pi * 2) + startAngle, clockwise: true)
        
        UIColor(white: 1.0, alpha: 0.2).setStroke()
        closePath.stroke()
    
    }
    
    

}
