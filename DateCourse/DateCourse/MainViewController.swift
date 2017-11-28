//
//  MainViewController.swift
//  DateCourse
//
//  Created by Gimin Moon on 11/20/17.
//  Copyright © 2017 Gimin Moon. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth


class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        setCourses()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller = storyboard?.instantiateViewController(withIdentifier: "addCourseMap")
//        self.navigationController!.pushViewController(controller!, animated: true)
//    }
//   
    func setCourses(){
        // why !?
        DataModel.sharedInstance.addCourse(course: CourseData(previewImage: "seattle", title: "Journey to Seattle", intro: "welcome to seattle everyone")!)
        DataModel.sharedInstance.addCourse(course: CourseData(previewImage: "los angeles", title: "One day trip inside Los Angeles", intro: "welcome to seattle everyone")!)
        DataModel.sharedInstance.addCourse(course: CourseData(previewImage: "newyork", title: "welcome to newyork", intro: "welcome to seattle everyone")!)
        DataModel.sharedInstance.addCourse(course: CourseData(previewImage: "seattle", title: "Journey to Seattle", intro: "welcome to seattle everyone")!)
        DataModel.sharedInstance.addCourse(course: CourseData(previewImage: "seattle", title: "Journey to Seattle", intro: "welcome to seattle everyone")!)
        DataModel.sharedInstance.addCourse(course: CourseData(previewImage: "seattle", title: "Journey to Seattle", intro: "welcome to seattle everyone")!)
        DataModel.sharedInstance.addCourse(course: CourseData(previewImage: "seattle", title: "Journey to Seattle", intro: "welcome to seattle everyone")!)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.sharedInstance.numberOfCourses()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CourseCell else{
            return UITableViewCell()
        }
        cell.previewImageView.image = UIImage(named: DataModel.sharedInstance.courses[indexPath.row].previewImage)
        cell.courseTitleLabel.text = DataModel.sharedInstance.courses[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let selectedVC:UITabBarController = storyboard.instantiateViewController(withIdentifier: "courseInfo") as! UITabBarController
        self.present(selectedVC, animated: true, completion: nil)
        
        //let selectedPlan = DataModel.sharedInstance.courses[indexPath.row]
        
    }

    @IBAction func SignOutButtonPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let homeVC:ViewController = storyboard.instantiateViewController(withIdentifier: "initialView") as! ViewController
            self.present(homeVC, animated: true, completion: nil)
        } catch{
            //handle error
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
