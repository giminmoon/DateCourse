//
//  CurrentItinerary.swift
//  DateCourse
//
//  Created by Gimin Moon on 8/29/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlacePicker


class Location {
    
    let googlePlaceHelper = GMSPlacesHelper.shared
    let imageCache = NSCache<NSString, UIImage>()
    var locationPlaceID: String?
    
    private var place: GMSPlace
    private var firstPhoto: UIImage?
    
    init(withGMSPlace place: GMSPlace) {
        self.place = place
    }
    
    func getName() -> String {
        return place.name
    }
    
    func getAddress() -> String? {
        return place.formattedAddress
    }
    
    func getImage() -> UIImage? {
        return firstPhoto
    }
    
    func getPlaceID() -> String {
        return place.placeID
    }
    
    func setImage(image: UIImage) {
        firstPhoto = image
    }
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return place.coordinate
    }
}

class CurrentItinerary {
    
    struct Notifications {
        static let LocationAdded   = Notification.Name("LocationAddedNotification")
        static let LocationRemoved  = Notification.Name("LocationRemovedNotification")
    }
 
    static let shared = CurrentItinerary()
    
    private var locations: [Location] = []
    var pathway : GMSMutablePath? = nil
    var lines : [GMSPolyline] = []
    var markers : [GMSMarker] = []
    
    var mapView: GMSMapView?
    
    func addLocation(place: GMSPlace) {
        let location = Location(withGMSPlace: place)
        self.locations.append(location)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notifications.LocationAdded, object: nil)
        }
    }
    
    func removeLocation() {
        self.locations.removeLast()
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notifications.LocationRemoved, object: nil)
        }
    }
    
    func addPhotoToLocation(index: Int, image: UIImage) {
        locations[index].setImage(image: image)
    }
    
    func removeAllLocations() {
        self.locations.removeAll()
    }
    
    func isEmpty() -> Bool {
        return self.locations.isEmpty
    }
    
    func LocationCount() -> Int {
        return locations.count
    }
    
    func getLocation(atIndex index: Int) -> Location {
        return locations[index]
    }
}

