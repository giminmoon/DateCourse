//
//  UIView + Convenience.swift
//  DateCourse
//
//  Created by Gimin Moon on 9/1/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit

extension UIView {
    func applyShadowRadius(radius: CGFloat, borderWidth: CGFloat) {
        
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath

        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
