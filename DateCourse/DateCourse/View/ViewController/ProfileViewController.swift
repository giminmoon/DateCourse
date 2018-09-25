//
//  ProfileViewController.swift
//  DateCourse
//
//  Created by Gimin Moon on 9/24/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    static func newProfileViewController() -> ProfileViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.present(LogInViewController.newLogInViewController(), animated: true, completion: nil)
        } catch let err {
            print(err)
        }
    }
}
