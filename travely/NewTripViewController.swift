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
    @IBOutlet weak var numTravellersPicker: UIPickerView!
    //picker view related data and functions
    // Tag 1 is Origin Picker
    // Tag 2 is Destination Picker
    // Tag 3 is Num of Travellers Picker
    let placesOrigin = ["-", "San Diego", "New York", "Rome"]
    let placesDestination = ["-", "San Diego", "New York", "Rome"]
    let numTravellersRange = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    var originPlacePicked = ""
    var destinationPlacePicked = ""
    var numOfTravellersPicked = ""
    
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
        else if pickerView.tag == 3{
            return numTravellersRange.count
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
        else if pickerView.tag == 3{
            return numTravellersRange[row]
        }
        else{
            return("Eror in picker")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            originPlacePicked = placesOrigin[row]
        }
        else if pickerView.tag == 2{
            destinationPlacePicked = placesDestination[row]
        }
        else if pickerView.tag == 3{
            numOfTravellersPicked = numTravellersRange[row]
        }
        else{
            print("Errror in picker")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originPlacePicked = ""
        destinationPlacePicked = ""
        numOfTravellersPicked = ""
        
        self.numTravellersPicker.dataSource = self;
        self.numTravellersPicker.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CalculatePressedNewTripToActivities"{
            let resultsViewController = segue.destination as! ActivitiesViewController
            resultsViewController.originLocation = originPlacePicked
            resultsViewController.destinaionLocation = destinationPlacePicked
            resultsViewController.numOfTravellers = numOfTravellersPicked
        }
    }
    
    
    //Add conditions to check before a segue is performed
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //If calculate button was pressed
        if identifier == "CalculatePressedNewTripToActivities" {
            
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
            guard originPlacePicked.count > 1 else {
                let alertController = UIAlertController(title: "Error", message:
                    "Origin not selected.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return false
                
            }
            
            guard destinationPlacePicked.count > 1 else {
                let alertController = UIAlertController(title: "Error", message:
                    "Destination not selected.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return false
                
            }
            
            //Check that the user didn't select the same destination and origin
            guard originPlacePicked != destinationPlacePicked else {
                let alertController = UIAlertController(title: "Error", message:
                    "Origin and destination must be differnt.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return false
            }
            
            //Check that departure date is not less than the current date
            guard departure_date_str >= current_date_str else {
                let alertController = UIAlertController(title: "Error", message:
                    "Deperture date can't be earlier than today.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return false
            }
            
            //Check that departure date is not greater than return date
            guard departure_date_str < return_date_str else {
                let alertController = UIAlertController(title: "Error", message:
                    "Return date must be past departure date.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    */
    
    //Only for demo purpose, after demo then change to segue to Activities
    @IBAction func switchToCost(_ sender: UIButton) {
        //Validating user input before button action
        //Get time values and change format of dates
        let current_date = Date()
        let departure_date = departureDatePicker.date
        let return_date = returnDatePicker.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let departure_date_str: String = formatter.string(from: departure_date)
        let return_date_str: String = formatter.string(from: return_date)
        let current_date_str: String = formatter.string(from: current_date)
        
        
        //check that user picked a county
        guard originPlacePicked.count > 1 else {
            let alertController = UIAlertController(title: "Error", message:
                "Origin not selected.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
        
        guard destinationPlacePicked.count > 1 else {
            let alertController = UIAlertController(title: "Error", message:
                "Destination not selected.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
        
        //Check that the user didn't select the same destination and origin
        guard originPlacePicked != destinationPlacePicked else {
            let alertController = UIAlertController(title: "Error", message:
                "Origin and destination must be differnt.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
    
        //Check that departure date is not less than the current date
        guard departure_date_str >= current_date_str else {
            let alertController = UIAlertController(title: "Error", message:
                "Deperture date can't be earlier than today.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        //Check that departure date is not greater than return date
        guard departure_date_str < return_date_str else {
            let alertController = UIAlertController(title: "Error", message:
                "Return date must be past departure date.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        //tabBarController?.selectedIndex = 2
        var costTab = self.tabBarController?.viewControllers![2] as! CostViewController
        costTab.originLocation = originPlacePicked
        costTab.destinationLocation = destinationPlacePicked
        costTab.departureDate = departure_date_str
        costTab.returnDate = return_date_str
        costTab.numTravellers = numOfTravellersPicked
        costTab.calculateButtonWasPressed = true
        
        tabBarController?.selectedIndex = 2
    }
 
}

