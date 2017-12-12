//
//  DataModel.swift
//  DateCourse
//
//  Created by Gimin Moon on 11/24/17.
//  Copyright © 2017 Gimin Moon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker
import CoreLocation

class DataModel{
    
    static let sharedInstance = DataModel()
    
    //array with all the date courses
    var courses = [CourseData]()
    
    //store the locations the user chose
    var locations = [GMSPlace]()
    
    init() {
        print("data model initialized")
    }
    
    func addCourse(course : CourseData){
        courses.append(course)
    }
    func numberOfCourses() -> Int {
        return courses.count
    }
    func deleteCourseWithIndex(index : Int){
        courses.remove(at: index)
    }
    
    func addLocation(location : GMSPlace)
    {
        locations.append(location)
    }
    func deleteLocationWithIndex(index : Int){
        locations.remove(at: index)
    }
    func numberOfLocations()->Int {
        return locations.count
    }
    func random()->Int{
        return Int(arc4random_uniform(UInt32(courses.count - 1)))
    }
}
