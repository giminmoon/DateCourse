//
//  ItineraryHeaderView.swift
//  DateCourse
//
//  Created by Gimin Moon on 9/4/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit

class ItineraryHeaderView: UIView {
    
    static let requredHeight: CGFloat = 60
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        
        Bundle.main.loadNibNamed("ItineraryHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
