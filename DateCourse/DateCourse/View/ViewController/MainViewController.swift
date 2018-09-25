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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refresher : UIRefreshControl!
    static var selectedCourse : CourseData? = nil
    let model = DataModel.sharedInstance
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView!.alwaysBounceVertical = true
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        observeCourses()
    }
    
    func observeCourses() {
        //call firebase manager to observe data
        let date = Date()
        print("before get courses")
        model.getInitialCourses {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
                let end = Date()
                print("\(end.timeIntervalSince(date))")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? CourseCollectionViewCell
            else{
                return UICollectionViewCell()
        }
        cell.configure(withCourseData: model.courses[indexPath.row])
        cell.imageView.clipsToBounds = true
        cell.imageView.layer.cornerRadius = 7
        return cell
    }
    
    //section header view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedVC = storyboard.instantiateViewController(withIdentifier: "CourseInfoMapNavigationController") as! UINavigationController
        let courseInfoMapVC = selectedVC.topViewController as! CourseInfoMapViewController
        courseInfoMapVC.selectedCourse = DataModel.sharedInstance.courses[indexPath.row]
        self.present(selectedVC, animated: true, completion: nil)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    @IBAction func SignOutButtonPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let homeVC:LogInViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            self.present(homeVC, animated: true, completion: nil)
        } catch{
            //handle error
        }
    }
}


