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

class CurrentItineary {
    
    struct Notifications {
        static let LocationAdded   = Notification.Name("LocationAddedNotification")
        static let LocationRemoved  = Notification.Name("LocationRemovedNotification")
    }
 
    static let shared = CurrentItineary()
    
    private var locations: [GMSPlace] = []
    
    func addLocation(place: GMSPlace) {
        self.locations.append(place)
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
    
    func removeAllLocations() {
        self.locations.removeAll()
    }
    
    func isEmpty() -> Bool {
        return self.locations.isEmpty
    }
    
    func LocationCount() -> Int {
        return locations.count
    }
    
    func getLocation(atIndex index: Int) -> GMSPlace {
        return locations[index]
    }
}

