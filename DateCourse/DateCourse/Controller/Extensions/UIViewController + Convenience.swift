//
//  UIViewController + Convenience.swift
//  DateCourse
//
//  Created by Gimin Moon on 8/31/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit

// extension to get keyboard out of the way
extension UIViewController{
    func hidKeyBoardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
