//
//  ItinearyCell.swift
//  DateCourse
//
//  Created by Gimin Moon on 8/31/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit
import GooglePlaces

class ItineraryCell: UITableViewCell, NibLoadableView, ReusableView {
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    var locationPlaceID: String?
    
    let imageCache = NSCache<NSString, UIImage>()
    
    let googlePlaceHelper = GMSPlacesHelper.shared
    static let requiredHeight: CGFloat = 300
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //centerView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        addressLabel.layer.addBorder(edge: .top, color: UIColor.lightGray, thickness: 0.5)
        self.backgroundColor = #colorLiteral(red: 0.9382043481, green: 0.9427983165, blue: 0.9034082294, alpha: 1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(withLocation location: Location, index: Int) {

        self.locationPlaceID = location.getPlaceID()
        
        DispatchQueue.main.async {
            if let imageFromCache = self.imageCache.object(forKey: location.getPlaceID() as NSString) {
                print("image from cache")
                self.locationImageView.image = imageFromCache
                return
            }
            
            self.googlePlaceHelper.loadFirstPhotoForPlace(placeID: location.getPlaceID()) { (image) in
                
                if self.locationPlaceID == location.getPlaceID() {
                    self.locationImageView.image = image
                    CurrentItinerary.shared.addPhotoToLocation(index: index, image: image)
                }
                self.imageCache.setObject(image, forKey: location.getPlaceID() as NSString)
                self.addressLabel.text = location.getAddress()
            }
        }
    }
}
