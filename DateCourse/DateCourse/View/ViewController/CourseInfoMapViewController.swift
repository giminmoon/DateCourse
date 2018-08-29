//
//  CourseInfoMapViewController.swift
//  DateCourse
//
//  Created by Gimin Moon on 11/25/17.
//  Copyright © 2017 Gimin Moon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker

class CourseInfoMapViewController: UIViewController, CLLocationManagerDelegate {
    var selectedCourse : CourseData?
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func setUpMap()
    {
    let camera = GMSCameraPosition.camera(withLatitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!, zoom: 15.0)
    
    //initialize googlemap
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    //addCourseMap.mapView?.delegate = (self as! GMSMapViewDelegate)
    mapView.settings.myLocationButton = true
    mapView.isMyLocationEnabled = true;
    
    //initialzie pathway
    let pathway = GMSMutablePath()
    
    //for loop to create all markers in the trace
    for location in (self.selectedCourse?.locations)!
    {
        let marker = GMSMarker()
        marker.position = (location.coordinate)
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.title = "\(location.name)"
        marker.map = mapView
        pathway.add(location.coordinate)
        let line = GMSPolyline(path: pathway)
        line.strokeColor = UIColor.red
        line.strokeWidth = 3.0
        line.map = mapView
    }

    self.view = mapView
    }

}
