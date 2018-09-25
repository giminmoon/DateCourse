//
//  AddItineraryTableViewCell.swift
//  DateCourse
//
//  Created by Gimin Moon on 9/5/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit

protocol AddLocationDelegate {
    func addLocationButtonTapped()
    func completeIntineraryTapped()
}

class AddItineraryTableViewCell: UITableViewCell, NibLoadableView, ReusableView {

    static let requiredHeight: CGFloat = 140
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var completePlanButton: UIButton!
    
    var addLocationDelegate: AddLocationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.lightGray, radius: 2.0, opacity: 0.35)
        completePlanButton.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.lightGray, radius: 2.0, opacity: 0.35)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addLocationButton(_ sender: UIButton) {
        addLocationDelegate?.addLocationButtonTapped()
    }
    
    @IBAction func completeItineraryButton(_ sender: UIButton) {
        addLocationDelegate?.completeIntineraryTapped()
    }
}
