//
//  LocationTitleTableViewCell.swift
//  DateCourse
//
//  Created by Gimin Moon on 9/5/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationTitleTableViewCell: UITableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var countLabel: UILabel!
    static let requiredHeight: CGFloat = 45
    let size:CGFloat = 25.0
    
    @IBOutlet weak var locationTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countLabel.textColor = UIColor.white
        countLabel.textAlignment = .center
        
        countLabel.layer.cornerRadius = size / 2
        countLabel.layer.borderWidth = 3.0
        countLabel.layer.masksToBounds = true
        countLabel.layer.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.568627451, blue: 0.6705882353, alpha: 1)
        countLabel.layer.borderColor = #colorLiteral(red: 0.9933039546, green: 0.5683370541, blue: 0.6695323812, alpha: 1)
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(withLocation location: Location, index: Int) {
        locationTitleLabel.text = location.getName()
        countLabel.text = "\(index)"
    }
}
