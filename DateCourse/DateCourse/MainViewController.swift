//
//  MainViewController.swift
//  DateCourse
//
//  Created by Gimin Moon on 11/20/17.
//  Copyright © 2017 Gimin Moon. All rights reserved.
//

import UIKit
import FirebaseAuth


class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var refresher : UIRefreshControl!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let model = DataModel.sharedInstance
    static var selectedCourse : CourseData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
        self.activityIndicator.startAnimating()
        model.getPreviewImages {
            self.collectionView.reloadSections(IndexSet(integer : 0))
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        }
    }
    @objc func loadData(){
        stopRefresher()
    }

    func stopRefresher() {
        self.refresher.endRefreshing()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return model.courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? CourseCollectionViewCell
            else{
                return UICollectionViewCell()
        }
        cell.courseTitle.text = model.courses[indexPath.row].title
        cell.imageView.image = model.previewImages[indexPath.row]
        cell.imageView.clipsToBounds = true
        cell.imageView.layer.cornerRadius = 7
        return cell
    }
    
    //section header view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
        return headerView
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CourseCell else{
//            return UITableViewCell()
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 250
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
//        let selectedVC:UITabBarController = storyboard.instantiateViewController(withIdentifier: "courseInfo") as! UITabBarController
//        MainViewController.selectedCourse = DataModel.sharedInstance.courses[indexPath.row]
//        //self.present(selectedVC, animated: true, completion: nil)
//        self.show(selectedVC, sender: MainViewController())
//        tableView.deselectRow(at: indexPath, animated: true)
//    }

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


