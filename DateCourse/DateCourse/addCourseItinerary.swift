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
import Firebase

class addCourseItinerary: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var completionHandler: (() -> Void)?
    var mainTable = UITableView!.self
    var onSave : ((_ course: CourseData)-> ())?
    //image and string(uid)
    var photos : [UIImage] = []
    var photoIDs : [String] = []
    var descriptions : [String] = []

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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addCourseMap.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ItineraryCell else{
            return UITableViewCell()
        }
        //saving the index row to each button's tag so we can access later in pickImage
        cell.titleLabel.text = addCourseMap.locations[indexPath.row].name
        cell.addImageButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.clear()
        dismiss(animated: true, completion: nil)
    }
  
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        let okAlert = UIAlertController(title: "Warning!", message: "Do you want to Save?", preferredStyle: .alert)
        okAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: {(action) in
            print("cancel saving")
            }))
        okAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            
            let cells = self.tableView.visibleCells as! Array<ItineraryCell>
            for cell in cells {
                self.descriptions.append((cell.descriptionTextField.text)!)
                self.photos.append((cell.placeImageView.image)!)
            
            //upload each photo to firebase storage - will work on connecting to each "course" later
                let currentImage = cell.placeImageView.image
                let storageImage = currentImage?.resizedTo1MB()!
                let imageName = NSUUID().uuidString
                self.photoIDs.append(imageName)
                
                let storageRef = Storage.storage().reference().child("\(imageName).png")
                if let uploadData = UIImagePNGRepresentation(storageImage!){
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        guard let metadata = metadata else {
                            print("error")
                            return
                        }
                        print("hu...")
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata.downloadURL()?.absoluteString
                        //self.photoIDs.append(downloadURL!)
                        print("adding..")
                        //get each photos downloadable image URL
//                        if let imageURL = downloadURL?.absoluteString{
//                            self.photoIDs.append(imageURL)
//                            print(imageURL)
//                        }
                        print(metadata)
                        })
                    }
            }
            
        guard let title = self.titleTextField.text, let intro = self.introTextField.text else{
            print("not valid form")
            return
        }
        //save each "course" to firebase under the current user.
//        let course = CourseData.init(title: title, intro: intro, locations: addCourseMap.locations, images: self.photos, descriptions : self.descriptions)
        let course = CourseData()
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else{
            return
        }
        let ref = Database.database(url: "https://datecourse-app.firebaseio.com/").reference()
            let userReference = ref.child("courses").childByAutoId()
            // need to fix saving locations
            print("photoID has : \(self.photoIDs.count) items ")
            let addingCourse = ["user": uid, "title": title, "intro": intro, "locations": title, "images": self.photoIDs, "descriptions" : self.descriptions] as [String : Any]
            userReference.updateChildValues(addingCourse, withCompletionBlock: {(err,ref) in
            if err != nil {
                print(err as Any)
                return
            }
            print("saved user in firebase")
        })
    
        //invoke save functionality to clear fields
        self.onSave?(course)
        self.clear()
        self.dismiss(animated: true, completion: nil)
        
        }))
        present(okAlert, animated: true, completion: nil)
    }
    
    func clear()
    {
        //clear pinpoints in map
        addCourseMap().clearAll()
        //clear table in addCourseItinerary
        tableView.reloadData()
        print("there are \(addCourseMap.locations.count) things in the table")
    }
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    selectedIndexPath = sender.tag
                    //print("index path : \(selectedIndexPath)")
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
                    self.selectedIndexPath = sender.tag
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
    
    func handleSelectImage(){
        
    }
  
    func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let tempImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("im picking? \(selectedIndexPath)")
            let cell = tableView.cellForRow(at: IndexPath.init(row: selectedIndexPath, section: 0)) as! ItineraryCell
            cell.placeImageView.translatesAutoresizingMaskIntoConstraints = false
            cell.placeImageView.contentMode = .scaleAspectFit
//            cell.placeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage)))
            cell.placeImageView.image = tempImage
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
extension UIImage {
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo1MB() -> UIImage? {
        guard let imageData = UIImagePNGRepresentation(self) else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = UIImagePNGRepresentation(resizedImage)
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        
        return resizingImage
    }
}
