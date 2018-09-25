//
//  AddCourseItineraryViewController.swift
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
import SCLAlertView
import JGProgressHUD

class AddCourseItineraryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var headerView: UIView! {
        didSet {
            let longPressGesture  = UILongPressGestureRecognizer(target: self, action: #selector(didTapMapView(_:)))
            headerView.addGestureRecognizer(longPressGesture)
        }
    }
    let manager = CLLocationManager()
    let googlePlaceHelper = GMSPlacesHelper.shared
    let imagePicker = UIImagePickerController()
    var completionHandler: (() -> Void)?
    var mainTable = UITableView?.self
    var onSave : (()-> ())?
    
    //image and string(uid)
    var photoIDs : [String] = []
    var descriptions : [String] = []
    
    let maxHeaderHeight: CGFloat = 156.0
    let minHeaderHeight: CGFloat = 0.0
    var previousScrollOffset: CGFloat = 0.0
    
    var pathway : GMSMutablePath? = nil
    var lines : [GMSPolyline] = []
    var markers : [GMSMarker] = []
    
    private var itinerary = CurrentItinerary.shared
    private var addButtonSectionIndex = 0
    
    var isMapViewPressed = false
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: UIView! {
        didSet {
            mapView.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.lightGray, radius: 2.0, opacity: 0.35)
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(ItineraryCell.self)
            tableView.register(AddItineraryTableViewCell.self)
            tableView.register(LocationTitleTableViewCell.self)
            tableView.register(ItineraryArrowTableViewCell.self)
            tableView.backgroundColor = #colorLiteral(red: 0.9382043481, green: 0.9427983165, blue: 0.9034082294, alpha: 1)
        }
    }
    
    var selectedIndexPath : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkPermission()
        self.hidKeyBoardWhenTapped()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
        else{
            print ("location is not enabled")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.headerHeightConstraint.constant = self.maxHeaderHeight
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.clear()
        dismiss(animated: true, completion: nil)
    }
    
    func setUpMap() {
        
        guard let location = manager.location else {
            print("in set up Map")
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            
            let alertView = AlertView(appearance: appearance)
            alertView.addButton("Done") {
                self.dismiss(animated: true, completion: nil)
            }
            alertView.showError("Error", subTitle: "Please check your device's Location settings and try again")
            
            return
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
        let frame = CGRect(x: 0, y: 0, width: self.mapView.bounds.width, height: self.mapView.bounds.height)
        itinerary.mapView = GMSMapView.map(withFrame: frame, camera: camera)
        itinerary.mapView?.camera = camera
        itinerary.mapView?.isMyLocationEnabled = true
        itinerary.mapView?.settings.setAllGesturesEnabled(false)
        itinerary.mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        //initialzie pathway
        self.pathway = GMSMutablePath()
        
        //initialize line
        let line = GMSPolyline(path: self.pathway)
        line.strokeColor = UIColor.red
        line.strokeWidth = 3.0
        line.map = itinerary.mapView
        itinerary.lines.append(line)
        
        self.mapView.addSubview(itinerary.mapView!)
    }
}


// MARK: - Methods for Saving Itinerary
extension AddCourseItineraryViewController {
    
    private func registerCourseIntoDatabase(course : [String : AnyObject], completion: @escaping() -> ()) {
        let ref = Database.database(url: "https://datecourse-app.firebaseio.com/").reference()
        let userReference = ref.child("courses").childByAutoId()
        
        userReference.updateChildValues(course, withCompletionBlock: {(err,ref) in
            if err != nil {
                print(err as Any)
                return
            }
            print(ref)
            completion()
        })
    }
    
    func saveItinerary(completion: @escaping () -> ()) {
        
        savePhoto(index: 0) {
            print("saved all photos")
            let user = Auth.auth().currentUser
            guard let uid = user?.uid else{
                return
            }
            
            let course = ["user": uid, "title": "New Course" , "intro": "", "locations": "helloo", "images": self.photoIDs, "descriptions" : ["hi my name is yuna"]] as [String : AnyObject]
            self.registerCourseIntoDatabase(course: course, completion: {
                completion()
            })
        }
    }
    
    func savePhoto(index: Int, completion: (() -> Void)?) {
        
        let locationCount = itinerary.LocationCount()
        
        if index == locationCount {
            completion!()
            return
        }
        
        savePhotoToDatabase(index: index) {
            
            if index + 1 <= locationCount {
                self.savePhoto(index: index+1, completion: completion)
            }
        }
    }
    
    func savePhotoToDatabase(index: Int, completion: @escaping () -> ()) {
        
        let currentLocation = self.itinerary.getLocation(atIndex: index)
        //upload each photo to firebase storage - will work on connecting to each "course" later
        let currentImage = currentLocation.getImage()
        guard let storageImage = currentImage?.resizedTo1MB() else{ return }
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(storageImage) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error{
                    print(error)
                    return
                }
                
                guard let metadata = metadata else {
                    print("error")
                    return
                }
                
                print(metadata)
                
                // Metadata contains file metadata such as size, content-type, and download URL.
                storageRef.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url?.absoluteString else { return }
                    //store the downloadable url's from each saved photo
                    self.photoIDs.append(downloadURL)
                    print(downloadURL)
                    completion()
                })
            })
        }
    }
    
    func clear()
    {
        //clear table in AddCourseItineraryViewController
        tableView.reloadData()
    }

}

// MARK: - Methods for Animations and Transitions
extension AddCourseItineraryViewController {
    
    @objc func didTapMapView(_ recognizer: UILongPressGestureRecognizer) {
        
        if recognizer.state == .began {
            longPressBegan()
        }
        else if recognizer.state == .ended {
            longPressEnded(isCancelled: false)
        } else if recognizer.state == .cancelled {
            longPressEnded(isCancelled: true)
        }
    }
    
    func longPressBegan() {
        guard !isMapViewPressed else {
            return
        }
        
        isMapViewPressed = true
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .beginFromCurrentState, animations: {
            self.mapView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    func longPressEnded(isCancelled: Bool) {
        guard isMapViewPressed else {
            return
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.mapView.transform = CGAffineTransform.identity
        }) { (finished) in
            self.isMapViewPressed = false
            if !isCancelled {
                let mapVC = AddCourseMapViewController.newAddCourseMapViewController()
                self.navigationController?.pushViewController(mapVC, animated: true)
            }
        }
    }
    
}

// MARK: - Methods for Core Location
extension AddCourseItineraryViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        setUpMap()
    }
}

// MARK: - Methods asking User permission for device access
extension AddCourseItineraryViewController {

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
}

// MARK: - Tableview Delegate methods
extension AddCourseItineraryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + itinerary.LocationCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addButtonSectionIndex == section && section > 0{
            return 4
        }
        else if section > 0 {
           return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == addButtonSectionIndex {
            if addButtonSectionIndex == 0 {
                let cell: AddItineraryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.addLocationDelegate = self
                return cell
            }
            else if indexPath.row == 2 {
                let cell: ItineraryArrowTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
            }
            else if indexPath.row == 3 {
                let cell: AddItineraryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.addLocationDelegate = self
                return cell
            }
        }
        
        if indexPath.section > 0 {
            if indexPath.row == 0 {
                let cell: LocationTitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                let location = itinerary.getLocation(atIndex: indexPath.section - 1)
                cell.configure(withLocation: location, index: indexPath.section)
                return cell
            }
            else if indexPath.row == 1 {
                let cell: ItineraryCell = tableView.dequeueReusableCell(for: indexPath)
                let location = itinerary.getLocation(atIndex: indexPath.section - 1)
                
                cell.configure(withLocation: location, index: indexPath.section - 1)
                return cell
            }
            else if indexPath.row == 2 {
                let cell: ItineraryArrowTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                return cell
            }
        }
        let cell = UITableViewCell()
        cell.backgroundColor = #colorLiteral(red: 0.9382043481, green: 0.9427983165, blue: 0.9034082294, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == addButtonSectionIndex {
            if addButtonSectionIndex == 0 {
                return AddItineraryTableViewCell.requiredHeight
            }
            if indexPath.row == 2 {
                return ItineraryArrowTableViewCell.requiredHeight
            }
            if indexPath.row == 3 {
                return AddItineraryTableViewCell.requiredHeight
            }
        }
            
        if indexPath.section > 0 {
            if (indexPath.row == 0) {
                return LocationTitleTableViewCell.requiredHeight
            }
            if (indexPath.row == 1) {
                return ItineraryCell.requiredHeight
            }
        }
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            // Calculate new header height
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.setScrollPosition(position: self.previousScrollOffset)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidStopScrolling()
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func setScrollPosition(position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.navigationController?.isNavigationBarHidden = true
            // Manipulate UI elements within the header here
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.navigationController?.isNavigationBarHidden = false
            // Manipulate UI elements within the header here
            self.view.layoutIfNeeded()
            
        })
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
           self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
}


// MARK: - Google Map Place Picker Delegate methods
extension AddCourseItineraryViewController: GMSPlacePickerViewControllerDelegate, AddLocationDelegate {
    
    func completeIntineraryTapped() {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        
        let alertView = AlertView(appearance: appearance)
        let progressView = JGProgressHUD(style: .dark)
        progressView.textLabel.text = "Creating Itinerary"
        alertView.addButton("Yes") {
            
            alertView.dismiss(animated: true, completion:nil)
            print("dismissed")
            progressView.show(in: self.view)
            self.saveItinerary(completion: {
                print("outside save itinerary")
                //Reset all fields
                progressView.dismiss(animated: true)
                self.dismiss(animated: true, completion: nil)
            })
        
        }
        
        alertView.addButton("Back") {
            alertView.dismiss(animated: true, completion: nil)
        }
        
        alertView.showInfo("Creating Itinerary", subTitle: "Would you like to proceed?")
    }
    
    func addLocationButtonTapped() {


        guard let location = manager.location else {
            
            let alertView = AlertView.shared
            //let alertView = AlertView(appearance: appearance)
            alertView.showError("Error", subTitle: "Please check your device's Location settings and try again")
            
            return
        }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.010,
                                               longitude: center.longitude + 0.010)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.01,
                                               longitude: center.longitude - 0.01)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)

        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePickerViewController(config: config)
        //link delegate to the controller
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
        
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: {
            self.itinerary.addLocation(place: place)
            if self.itinerary.LocationCount() > 1 {
                self.tableView.isScrollEnabled = true
            }
            
            self.addButtonSectionIndex += 1
            
            // add a marker for the selected place
            let marker = GMSMarker()
            marker.position = (place.coordinate)
            marker.icon = GMSMarker.markerImage(with: .black)
            marker.title = "\(place.name)"
            
            marker.snippet = "\(self.itinerary.LocationCount())"
            marker.map = self.itinerary.mapView
            self.itinerary.markers.append(marker)
            
            //connect a path between the new place and most recent place
            self.pathway?.add(place.coordinate)
            let line = GMSPolyline(path: self.pathway)
            line.map = self.itinerary.mapView
            self.itinerary.lines.append(line)
            
            self.itinerary.mapView?.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 13.0)
        })
    }

    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
}
