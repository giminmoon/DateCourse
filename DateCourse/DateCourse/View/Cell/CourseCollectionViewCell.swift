//
//  CourseCollectionViewCell.swift
//  DateCourse
//
//  Created by Gimin Moon on 3/23/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var keywordsLabel: UILabel!
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var courseTitle: UILabel!
    
    var currentCourse:CourseData!
    
    /// <#Description#>
    ///
    /// - Parameter courseData: <#courseData description#>
    func configure(withCourseData courseData: CourseData) {
        self.currentCourse = courseData
        self.courseTitle.text = currentCourse.courseTitle
        imageView.loadImageUsingUrlString(urlString: currentCourse.urls[0])
    }

    /// <#Description#>
    ///
    /// - Parameter urlString: <#urlString description#>
    

    
}
