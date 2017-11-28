//
//  CourseDataModel.swift
//  DateCourse
//
//  Created by Gimin Moon on 11/24/17.
//  Copyright © 2017 Gimin Moon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class CourseData{
    
    //var images : Dictionary<NSData, String>
    var previewImage : String
    var title : String
    var intro : String
    var coolPersonName : String
    
    //add array of the following
//    static var locations : [GMSPlace] = []
//    static var mapView : GMSMapView? = nil
//    static var pathway : GMSMutablePath? = nil
//    static var lines : [GMSPolyline] = []
//    static var markers : [GMSMarker] = []
    
    init?(previewImage: String, title : String, intro : String) {
        self.title = title
        self.intro = intro
        self.previewImage = previewImage
        self.coolPersonName = "Yuna :)"
    }
}
