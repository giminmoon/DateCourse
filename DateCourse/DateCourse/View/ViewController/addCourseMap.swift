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
    private var currentItineary = CurrentItineary.shared
    static var locations : [GMSPlace] = []
    static var mapView : GMSMapView? = nil
    static var pathway : GMSMutablePath? = nil
    static var lines : [GMSPolyline] = []
    static var markers : [GMSMarker] = []
    //static var markerToLocation = [GMSMarker : GMSPlace]()
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //use current location
        setManager()
    }
    
    func clearAll()
    {
        print("clearing view")
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
        currentItineary.removeAllLocations()
        //addCourseMap.locations.removeAll()
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
        if !currentItineary.isEmpty() {
            currentItineary.removeLocation()
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
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        currentItineary.addLocation(place: place)
        
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
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
    
}



