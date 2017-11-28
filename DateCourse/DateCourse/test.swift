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

class test: UIViewController, GMSPlacePickerViewControllerDelegate, CLLocationManagerDelegate{
    
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
//
//    }
    func setUpMap()
    {
        let camera = GMSCameraPosition.camera(withLatitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!, zoom: 15.0)
        
        test.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        test.mapView?.settings.myLocationButton = true

        //Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = (manager.location?.coordinate)!
        marker.title = "Current Location"
        marker.snippet = "Choose locations"
        marker.map = test.mapView
        
        test.pathway = GMSMutablePath()
        test.pathway?.add((manager.location?.coordinate)!)
        
        let line = GMSPolyline(path: test.pathway)
        line.strokeColor = UIColor.red
        line.strokeWidth = 3.0
        line.map = test.mapView
        test.lines.append(line)
        
        view = test.mapView

    }
    
    @IBAction func pickPlace(_ sender: UIBarButtonItem) {
        
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
        if !test.locations.isEmpty {
            test.locations.remove(at: test.locations.count - 1)
            print("\(test.locations.count) places remaining")
        }
        //delete last path and marker
        if((test.pathway?.count())! > 1)
        {
            print("deleting coordinates and markers")
            
            //set last line and marker to nil
            test.pathway?.removeLastCoordinate()
            test.lines[test.lines.count - 1].map = nil
            test.lines.remove(at: test.lines.count - 1)
            test.markers[test.markers.count - 1].map = nil
            test.markers.remove(at: test.markers.count - 1)
        }
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        test.locations.append(place)
        
        // add a marker for the selected place
        let marker = GMSMarker()
        marker.position = (place.coordinate)
        print("\(place.coordinate.latitude) and \(place.coordinate.longitude)")
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.title = "\(place.name)"
        marker.snippet = "\(test.locations.count)"
        marker.map = test.mapView
        test.markers.append(marker)
        
        //connect a path between the new place and most recent place
        test.pathway?.add(place.coordinate)
        let line = GMSPolyline(path: test.pathway)
        line.map = test.mapView
        test.lines.append(line)
        
        print("added a place!!!!!")
        print("there are \(test.locations.count) in the array")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    
}

