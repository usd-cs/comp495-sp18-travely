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
    
    //If calculate button is pressed then initiate action
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        
        //Get time values and change format of dates
        let current_date = Date()
        let departure_date = departureDatePicker.date
        let return_date = returnDatePicker.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let departure_date_str: String = formatter.string(from: departure_date)
        let return_date_str: String = formatter.string(from: return_date)
        let current_date_str: String = formatter.string(from: current_date)
        
        //Check that departure date is not less than the current date
        guard departure_date_str >= current_date_str else {
            print("Invalid Dates: departure time less than current date")
            return
        }
        
        //Check that departure date is not greater than return date
        guard departure_date_str <= return_date_str else {
            print("Invalid Dates: departure time is greater than return date")
            return
        }
        
        //TODO: Implement calculate button function
    }
}

