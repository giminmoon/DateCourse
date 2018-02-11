//
//  addCourse.swift
//  DateCourse
//
//  Created by Gimin Moon on 11/24/17.
//  Copyright © 2017 Gimin Moon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker
import CoreLocation

class addCourseMap: UIViewController, GMSPlacePickerViewControllerDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var map: UIView!
    static var locations : [GMSPlace] = []
    static var mapView : GMSMapView? = nil
    static var pathway : GMSMutablePath? = nil
    static var lines : [GMSPolyline] = []
    static var markers : [GMSMarker] = []
    //static var markerToLocation = [GMSMarker : GMSPlace]()
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        //GMSServices.provideAPIKey("AIzaSyArL3VPne-CLMZkvgdnyrTOUnZCdR8Rnjc")
        //use current location
        setManager()
    }
    func clearAll()
    {
        print("clearing view")
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
        addCourseMap.locations.removeAll()
    }
    func setManager(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
            setUpMap()
        }
        else{
            print ("location is not enabled")
        }
    }
    //    cllocationmanager delegate func
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let location = locations[0]
    //
    //    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let newLocation = locations.last
    //
    //    }
    //    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    //        let errorType = nil
    //    }
    func setUpMap()
    {
       let camera = GMSCameraPosition.camera(withLatitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!, zoom: 15.0)
    
        //initialize googlemap
        addCourseMap.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //addCourseMap.mapView?.delegate = (self as! GMSMapViewDelegate)
        addCourseMap.mapView?.settings.myLocationButton = true
        addCourseMap.mapView?.isMyLocationEnabled = true;
        
        //initialzie pathway
        addCourseMap.pathway = GMSMutablePath()
       
        //initialize line
        let line = GMSPolyline(path: addCourseMap.pathway)
        line.strokeColor = UIColor.red
        line.strokeWidth = 3.0
        line.map = addCourseMap.mapView
        addCourseMap.lines.append(line)
        self.view = addCourseMap.mapView
    }
    
    @IBAction func pickPlace(_ sender: UIBarButtonItem) {
        //make it the last picked location
        let center = CLLocationCoordinate2D(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
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
    
    @IBAction func undoButtonPressed(_ sender: UIBarButtonItem) {
        
        //delete last location
        if !addCourseMap.locations.isEmpty {
            addCourseMap.locations.remove(at: addCourseMap.locations.count - 1)
            print("\(addCourseMap.locations.count) places remaining")
        }
       
        //delete last path and marker
        if (addCourseMap.pathway?.count())! > 0
        {
            print("deleting coordinates and markers")
            //set last line and marker to nil
            addCourseMap.pathway?.removeLastCoordinate()
            addCourseMap.lines[addCourseMap.lines.count - 1].map = nil
            addCourseMap.lines.remove(at: addCourseMap.lines.count - 1)
            addCourseMap.markers[addCourseMap.markers.count - 1].map = nil
            addCourseMap.markers.remove(at: addCourseMap.markers.count - 1)
            
            //delete cell in itinieray
            let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
            let itinVC = navController.topViewController as! addCourseItinerary
            
           // print("\(addCourseMap.locations.count - 1)")
            
            let indexPath = IndexPath(row: addCourseMap.locations.count, section: 0)
            itinVC.tableView.beginUpdates()
            itinVC.tableView.deleteRows(at: [indexPath], with: .automatic)
            itinVC.tableView.endUpdates()
        }
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        addCourseMap.locations.append(place)
        
        //To-Do #1: check if this place has been already added
        
        // add a marker for the selected place
        let marker = GMSMarker()
        marker.position = (place.coordinate)
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.title = "\(place.name)"
        marker.snippet = "\(addCourseMap.locations.count)"
        marker.map = addCourseMap.mapView
        addCourseMap.markers.append(marker)
        
        //connect a path between the new place and most recent place
        addCourseMap.pathway?.add(place.coordinate)
        let line = GMSPolyline(path: addCourseMap.pathway)
        line.map = addCourseMap.mapView
        addCourseMap.lines.append(line)
        
        //after adding, make the camera to the coordinates of the added place
        //self.view = addCourseMap.mapView
        addCourseMap.mapView?.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
    
        //add a cell in itinieray
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let itinVC = navController.topViewController as! addCourseItinerary
        print("\(addCourseMap.locations.count - 1)")
        
        let indexPath = IndexPath(row: addCourseMap.locations.count - 1, section: 0)
        //crashes when I directly go to Create ->  + -> pick place
        //doenst crash when I go Create -> tap itinerary fisrt -> go back to map -> + -> pick place
        itinVC.tableView.beginUpdates()
        itinVC.tableView.insertRows(at: [indexPath], with: .automatic)
        itinVC.tableView.endUpdates()
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
    
}



