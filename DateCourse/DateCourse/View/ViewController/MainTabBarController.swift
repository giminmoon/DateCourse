//
//  MainTabBarController.swift
//  DateCourse
//
//  Created by Gimin Moon on 5/22/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.hidKeyBoardWhenTapped()
    }
    
    //method for selecting pop up ViewControllers under MainTabBarController
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is EmptyVCViewController {
            if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "newTabBarController") {
                tabBarController.present(newVC, animated: true)
                return false
            }
        }
        return true
    }



}
