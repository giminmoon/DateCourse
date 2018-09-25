//
//  CALayer+Border.swift
//  DateCourse
//
//  Created by Gimin Moon on 8/31/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit
import Foundation

extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
    func applyShadow(withColor color: CGColor = #colorLiteral(red: 0.6861582791, green: 0.6861582791, blue: 0.6861582791, alpha: 1), opacity: Float = 0.75, offset: CGSize = CGSize(width: 0, height: 2) , radius: CGFloat = 12) {
        shadowColor   = color
        shadowOpacity = opacity
        shadowOffset  = offset
        shadowRadius  = radius
    }
}
