//
//  CustomImageView.swift
//  DateCourse
//
//  Created by Gimin Moon on 8/27/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    var imageUrlString: String?
    let imageCache = NSCache<NSString, UIImage>()
    
    func loadImageUsingUrlString(urlString: String) {
        imageUrlString = urlString
        let url = NSURL(string: urlString)
        
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            print("have image from cache")
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, responses, error) in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                self.imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            }
        }).resume()
    }
 }
