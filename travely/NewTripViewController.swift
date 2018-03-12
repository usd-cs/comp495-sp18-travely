//
//  NewTripViewController.swift
//  travely
//
//  Created by Spencer Mcdonald on 3/3/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//
// View Controller for New Trip (Main Screen) tab

import UIKit

class NewTripViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //outlets declarations
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    @IBOutlet weak var returnDatePicker: UIDatePicker!
    
    @IBOutlet weak var originPicker: UIPickerView!
    @IBOutlet weak var destinationPicker: UIPickerView!
    
    //picker view related dtat and functions
    // Tag 1 is Origin Picker
    // Tag 2 is Destination Picker
    let placesOrigin = ["-", "San Diego", "New York", "Rome"]
    let placesDestination = ["-", "San Diego", "New York", "Rome"]
    
    var originPlacePicked = ""
    var destinationPlacePicked = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return placesOrigin.count
        }
        else if pickerView.tag == 2{
            return placesDestination.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return placesOrigin[row]
        }
        else if pickerView.tag == 2{
            return placesDestination[row]
        }
        else{
            return("Errror in picker")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            originPlacePicked = placesOrigin[row]
            print("Selected : \(placesOrigin[row])")
        }
        else if pickerView.tag == 2{
            destinationPlacePicked = placesDestination[row]
            print("Selected : \(placesDestination[row])")
        }
        else{
            print("Errror in picker")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originPlacePicked = ""
        destinationPlacePicked = ""
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //If calculate button is pressed then initiate action
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        
        //Validating user input before button action
        //Get time values and change format of dates
        let current_date = Date()
        let departure_date = departureDatePicker.date
        let return_date = returnDatePicker.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let departure_date_str: String = formatter.string(from: departure_date)
        let return_date_str: String = formatter.string(from: return_date)
        let current_date_str: String = formatter.string(from: current_date)
        
        //check that user picked a county
        guard originPlacePicked.count > 1, destinationPlacePicked.count > 1 else{
            print("Invalid Oigin or Destination: not Selected")
            return
        }
        
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
        
        //TODO: Implement calculate button action
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CalculatePressedNewTripToActivities"{
            let resultsViewController = segue.destination as! ActivitiesViewController
            resultsViewController.originLocation = originPlacePicked
            resultsViewController.destinaionLocation = destinationPlacePicked
        }
    }
}

