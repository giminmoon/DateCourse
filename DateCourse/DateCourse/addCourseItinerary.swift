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
    var completionHandler: (() -> Void)?
    var mainTable = UITableView!.self
    var onSave : ((_ course: CourseData)-> ())?

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
        selectedIndexPath = indexPath.row
        cell.titleLabel.text = addCourseMap.locations[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
//        let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
//        let selectedVC:UINavigationController = storyboard.instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
//        self.present(selectedVC, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
  
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let okAlert = UIAlertController(title: "Warning!", message: "Do you want to Save?", preferredStyle: .alert)
        okAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: {(action) in
            print("cancel saving")
            }))
        okAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            let course = CourseData.init(title: self.titleTextField.text!, intro: self.introTextField.text!, locations: addCourseMap.locations)
            self.onSave?(course)
            self.clear()
            self.dismiss(animated: true, completion: nil)
        }))
        present(okAlert, animated: true, completion: nil)
    }
    
    func clear()
    {
        addCourseMap().clearAll()
    }
    @IBAction func addImagePressed(_ sender: Any) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            print("index path : \(selectedIndexPath)")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    self.imagePicker.modalPresentationStyle = .popover
                    self.imagePicker.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
                    self.imagePicker.popoverPresentationController?.sourceView = view
                    self.present(imagePicker, animated: true, completion: nil)
                }
        
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    self.imagePicker.modalPresentationStyle = .popover
                    self.imagePicker.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
                    self.imagePicker.popoverPresentationController?.sourceView = self.view
                    self.present(self.imagePicker, animated: true, completion: nil)
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
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("im picking?")
            let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ItineraryCell
            cell.placeImageView.contentMode = .scaleAspectFit
            cell.placeImageView.image = pickedImage
            imagePicker.dismiss(animated: true, completion: nil)
        }
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
