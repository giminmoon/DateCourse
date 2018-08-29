//
//  User.swift
//  DateCourse
//
//  Created by Gimin Moon on 5/24/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import Foundation

class User {
    var firstName : String?
    var lastName : String?
    var userName : String?
    var userEmail : String?
    var profilePhoto : String?
    var gender : sex?
    var userCourses : [CourseData] = []
    var favoriteCourses : [CourseData] = []
}

enum sex {
    case Male
    case Female
}
