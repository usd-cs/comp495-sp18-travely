//
//  NewTripViewController.swift
//  travely
//
//  Created by Spencer Mcdonald on 3/3/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//
// View Controller for New Trip (Main Screen) tab

import UIKit

class NewTripViewController: UIViewController {

    @IBOutlet weak var departureDatePicker: UIDatePicker!
    @IBOutlet weak var returnDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}

