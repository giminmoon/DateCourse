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
import SCLAlertView

class AddCourseMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: UIView!
    private var itinerary = CurrentItinerary.shared
    static var locations : [GMSPlace] = []
    var mapView : GMSMapView?
    static var pathway : GMSMutablePath? = nil
    static var lines : [GMSPolyline] = []
    static var markers : [GMSMarker] = []
    //static var markerToLocation = [GMSMarker : GMSPlace]()
    let manager = CLLocationManager()
    
    static func newAddCourseMapViewController() -> AddCourseMapViewController {
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as! AddCourseMapViewController
        return mapVC
    }
    
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
        itinerary.removeAllLocations()
        //AddCourseMapViewController.locations.removeAll()
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
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
        
        //initialize googlemap
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.settings.myLocationButton = true
        mapView?.isMyLocationEnabled = true;
        
        for (i,marker) in itinerary.markers.enumerated() {
            marker.map = mapView
            itinerary.pathway?.add(itinerary.getLocation(atIndex: i).getCoordinates())
            
            let line = GMSPolyline(path: itinerary.pathway)
            line.map = mapView
            
        }
        
        self.view = mapView
    }
    
    @IBAction func undoButtonPressed(_ sender: UIBarButtonItem) {
        
        //delete last location
        if !itinerary.isEmpty() {
            itinerary.removeLocation()
        }
       
        //delete last path and marker
        if (AddCourseMapViewController.pathway?.count())! > 0
        {
            print("deleting coordinates and markers")
            //set last line and marker to nil
            AddCourseMapViewController.pathway?.removeLastCoordinate()
            AddCourseMapViewController.lines[AddCourseMapViewController.lines.count - 1].map = nil
            AddCourseMapViewController.lines.remove(at: AddCourseMapViewController.lines.count - 1)
            AddCourseMapViewController.markers[AddCourseMapViewController.markers.count - 1].map = nil
            AddCourseMapViewController.markers.remove(at: AddCourseMapViewController.markers.count - 1)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}



