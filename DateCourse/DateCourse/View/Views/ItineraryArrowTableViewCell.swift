//
//  ItineraryArrowTableViewCell.swift
//  DateCourse
//
//  Created by Gimin Moon on 9/10/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit

class ItineraryArrowTableViewCell: UITableViewCell, NibLoadableView, ReusableView  {
    
    static let requiredHeight: CGFloat = 50.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = #colorLiteral(red: 0.9382043481, green: 0.9427983165, blue: 0.9034082294, alpha: 1)
    }

}
