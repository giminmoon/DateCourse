//
//  addCourseItinerary.swift
//  DateCourse
//
//  Created by Gimin Moon on 11/24/17.
//  Copyright © 2017 Gimin Moon. All rights reserved.
//

import UIKit
import Photos
import GoogleMaps
import GooglePlacePicker
import CoreLocation

class addCourseItinerary: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var introTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var selectedIndexPath : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkPermission()
        self.hidKeyBoardWhenTapped()
        // need two delegates (imagepicker and navitagtion controller) **
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        print("im in apparently itinerary?")
        // Do any additional setup after loading the view.
    }
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    //dynamically create cells based off on the number of locations set in the map tab
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addCourseMap.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ItineraryCell else{
            return UITableViewCell()
        }
        cell.imageView?.tag = indexPath.row
        cell.titleLabel.text = addCourseMap.locations[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
//        let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
//        let selectedVC:UINavigationController = storyboard.instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
//        self.present(selectedVC, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //save the path
        //alert are you sure?
        
        let okAlert = UIAlertController(title: "Warning!", message: "Do you want to Save?", preferredStyle: .alert)
        okAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: {(action) in
            print("cancel saving")
            }))
        okAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            let course = CourseData.init(title: self.titleTextField.text!, intro: self.introTextField.text!, locations: addCourseMap.locations)
            DataModel.sharedInstance.addCourse(course: course)
            self.clear()
            self.dismiss(animated: true, completion: nil)
            //go back to main menu
        }))
        present(okAlert, animated: true, completion: nil)
    }
    
    func clear()
    {
        //clear all textfields and exit
        
        addCourseMap().clearAll()
        print("clear everything")
    }
    @IBAction func addImagePressed(_ sender: Any) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")

            self.selectedIndexPath = (sender as AnyObject).tag
            self.present(imagePicker, animated: true, completion: nil)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    self.selectedIndexPath = (sender as AnyObject).tag
                    self.present(imagePicker, animated: true, completion: nil)
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    func imagePickerControllerDidCancel(_ imagePicker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            dismiss(animated: true, completion: nil)
//            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            print("im picking?")
//            let selectedPath = IndexPath(row: self.selectedIndexPath, section: 0)
//            let cell = tableView(tableView, cellForRowAt: selectedPath) as! ItineraryCell
//            cell.placeImageView.contentMode = .scaleAspectFit
//            cell.placeImageView.image = pickedImage
//
//        }
    }
}

// extension to get keyboard out of the way
extension UIViewController{
    func hidKeyBoardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
