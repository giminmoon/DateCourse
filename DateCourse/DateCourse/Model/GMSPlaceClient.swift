//
//  GMSPlaceClient.swift
//  DateCourse
//
//  Created by Gimin Moon on 9/6/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import Foundation
import GooglePlaces

class GMSPlacesHelper {
    static let shared = GMSPlacesHelper()
    
    func loadFirstPhotoForPlace(placeID: String, completion: @escaping (UIImage) -> ()) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto, completion: {
                        photo in
                        completion(photo)
                    })
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, completion: @escaping(UIImage)-> ()) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                completion(photo!)
            }
        })
    }
}
