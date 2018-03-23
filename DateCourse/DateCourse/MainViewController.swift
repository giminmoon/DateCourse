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
import Firebase
import Alamofire
import AlamofireImage

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var courses = [CourseData]()
    
    static var selectedCourse : CourseData? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCourses()
    }
    
    func fetchCourses(){
        Database.database().reference().child("courses").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let course = CourseData()
                course.descriptions = dictionary["descriptions"] as! [String]
                course.urls = dictionary["images"] as! [String]
                course.intro = dictionary["intro"] as! String
                course.title = dictionary["title"] as! String
                course.user = dictionary["user"] as! String
                self.courses.append(course)

                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return DataModel.sharedInstance.numberOfCourses()
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CourseCell else{
            return UITableViewCell()
        }
        
        let course = courses[indexPath.row]
        let previewImageURL = course.urls[0]
        print(previewImageURL)
        

        let url = URL.init(string: previewImageURL)
//        async call to set image using Alamofire
        Alamofire.request(url!).responseImage { (response) in
            if let responseImage = response.result.value {
                cell.previewImageView.contentMode = .scaleAspectFit
                cell.previewImageView.image = responseImage
                cell.courseTitleLabel.text = course.title
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let selectedVC:UITabBarController = storyboard.instantiateViewController(withIdentifier: "courseInfo") as! UITabBarController
        MainViewController.selectedCourse = DataModel.sharedInstance.courses[indexPath.row]
        //self.present(selectedVC, animated: true, completion: nil)
        self.show(selectedVC, sender: MainViewController())
        tableView.deselectRow(at: indexPath, animated: true)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue for adding
        let tabBar : UITabBarController = segue.destination as! UITabBarController
        let nav = tabBar.viewControllers![1] as! UINavigationController
        let itinVC = nav.topViewController as! addCourseItinerary
        itinVC.onSave = onSave
    }
    
    //example of completion block for data transfer !!
    //no longer in use after implementation of firebase for data persistence
    func onSave(_ course : CourseData) -> () {
//        DataModel.sharedInstance.addCourse(course: course)
//        let indexPath = IndexPath(row: DataModel.sharedInstance.numberOfCourses() - 1, section: 0)
//        print("how many images? : \(course.images.count)")
//        tableView.beginUpdates()
//        tableView.insertRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
    }
}


