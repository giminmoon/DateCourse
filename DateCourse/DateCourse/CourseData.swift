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

    //add array of the following
    var locations : [GMSPlace] = []

    init(previewImage: String, title : String, intro : String) {
        self.title = title
        self.intro = intro
        self.previewImage = previewImage
        locations = []
    }
    init(title : String, intro : String, locations : [GMSPlace]) {
        self.title = title
        self.intro = intro
        self.locations = locations
        self.previewImage = ""
    }
}
