//
//  RoundShadowView.swift
//  DateCourse
//
//  Created by Gimin Moon on 8/31/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit

class RoundShadowView: UIView {
    private var theShadowLayer: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect: self.bounds)
        
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath2.cgPath
        
        self.layer.addBorder(edge: .all, color: UIColor.lightGray, thickness: 1.0)
    }
}
