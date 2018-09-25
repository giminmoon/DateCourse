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
            let ItineraryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItineraryVC")
            let navigationController = UINavigationController(rootViewController: ItineraryVC)
            tabBarController.present(navigationController, animated: true)
            return false
        }
        return true
    }



}
