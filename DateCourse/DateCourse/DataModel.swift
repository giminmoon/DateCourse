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
    
    func getPreviewImages(completion : @escaping () -> Void) {
        getCourses {
            for course in self.courses {
                let previewImageURL = course.urls[0]
                let url = URL.init(string: previewImageURL)
                
                //download images with url
                let data = try? Data(contentsOf: url!)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    self.previewImages.append(image!)
                }
            }
            completion()
        }
    }
    
    func getCourses(completion: @escaping () -> Void) {
        Database.database().reference().child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for c in dictionary{
                    let course = CourseData()
                    course.descriptions = c.value["descriptions"] as! [String]
                    course.urls = c.value["images"] as! [String]
                    course.intro = c.value["intro"] as! String
                    course.title = c.value["title"] as! String
                    course.user = c.value["user"] as! String
                    self.courses.append(course)
                }
                completion()
            }
            
        })
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
