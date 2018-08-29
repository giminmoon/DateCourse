//
//  TempViewController.swift
//  DateCourse
//
//  Created by Gimin Moon on 5/24/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit

class TempViewController: UIViewController, UITableViewDelegate {
    
    private var tableView : UITableView!
    private var texts : [String] = ["First Name", "Last Name", "Email Address", "Password"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        createTable()
    }
    
    func createTable() {
        
    }
    

}
