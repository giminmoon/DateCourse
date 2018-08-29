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
import FirebaseCore
import FirebaseAuth
import Firebase
import Alamofire
import AlamofireImage

class DataModel{
    
    static let sharedInstance = DataModel()
    
    var courses = [CourseData]()
    var locations = [GMSPlace]()
    var previewImages = [UIImage]()
    
    init() {
    }
    
    func getInitialCourses(completion: @escaping () -> Void) {
        
        Database.database().reference().child("courses").observe(.value, with: { (snapshot) in
            self.courses.removeAll()
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.createCourseData(dictionary: dictionary)
            }
            completion()
        })
    }
    
    func createCourseData(dictionary: [String: AnyObject]) {
        for c in dictionary {
            let descriptions = c.value["descriptions"] as! [String]
            let urls = c.value["images"] as! [String]
            let intro = c.value["intro"] as! String
            let title = c.value["title"] as! String
            let user = c.value["user"] as! String
            
            let course = CourseData.init(description: descriptions, url: urls, intro: intro, title: title, user: user)
            print("course added")
            self.courses.append(course)
        }
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
//
//    func addLocation(location : GMSPlace)
//    {
//        locations.append(location)
//    }
//    func deleteLocationWithIndex(index : Int){
//        locations.remove(at: index)
//    }
//    func numberOfLocations()->Int {
//        return locations.count
//    }
//    func random()->Int{
//        return Int(arc4random_uniform(UInt32(courses.count - 1)))
//    }
}
