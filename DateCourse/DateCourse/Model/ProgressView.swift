//
//  ProgressView.swift
//  DateCourse
//
//  Created by Gimin Moon on 8/29/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit
import JGProgressHUD

class ProgressView: JGProgressHUD {
    
    static let shared = ProgressView(style: .dark)
    
    func showHUD(title: String) {
        
        showHUD(title: title, subTitle: nil, maxTime: nil)
    }
    
    func showHUD() {
        showHUD(title: nil, subTitle: nil, maxTime: nil)
    }
    
    func dismissHUD() {
        dismiss(animated: true)
    }
    
    func showHUD(title: String?, subTitle: String?, maxTime: Double?) {
        
        self.dismiss()
        if let title = title {
            self.textLabel.text = title
        }
        if let subTitle = subTitle {
            self.detailTextLabel.text = subTitle
        }
        
        self.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        self.backgroundColor = UIColor.black
        
        if let window = UIApplication.shared.keyWindow { self.show(in: window) }
        
        if let maxTime = maxTime {
            self.dismiss(afterDelay: maxTime)
        }
    }
}
