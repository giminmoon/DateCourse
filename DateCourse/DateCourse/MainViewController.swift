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
    
    @IBOutlet weak var tableView: UITableView!
    
    static var selectedCourse : CourseData? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //setCourses()
    }
    
    func setCourses(){
        DataModel.sharedInstance.addCourse(course: CourseData(previewImage: "seattle", title: "Journey to Seattle", intro: "welcome to seattle everyone"))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("helloooo \(DataModel.sharedInstance.numberOfCourses())")
        return DataModel.sharedInstance.numberOfCourses()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CourseCell else{
            return UITableViewCell()
        }
        
        cell.previewImageView.image = DataModel.sharedInstance.courses[indexPath.row].images[0]
        cell.previewImageView.contentMode = .scaleAspectFit
        cell.courseTitleLabel.text = DataModel.sharedInstance.courses[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let selectedVC:UITabBarController = storyboard.instantiateViewController(withIdentifier: "courseInfo") as! UITabBarController
        MainViewController.selectedCourse = DataModel.sharedInstance.courses[indexPath.row]
        //self.present(selectedVC, animated: true, completion: nil)
        self.show(selectedVC, sender: MainViewController())
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
    func onSave(_ course : CourseData) -> () {
        DataModel.sharedInstance.addCourse(course: course)
        let indexPath = IndexPath(row: DataModel.sharedInstance.numberOfCourses() - 1, section: 0)
        print("how many images? : \(course.images.count)")
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
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
