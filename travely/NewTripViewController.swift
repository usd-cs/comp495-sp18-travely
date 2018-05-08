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
    let placesOrigin = ["-", "Barcelona", "Beijing", "Dubai", "Honolulu", "London", "Moscow", "Munich", "New York City", "Rome", "San Diego", "Seattle"]
    let placesDestination = ["-", "Barcelona", "Beijing", "Dubai", "Honolulu", "London", "Moscow", "Munich", "New York City", "Rome", "San Diego", "Seattle"]
    let numTravellersRange = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    var originPlacePicked = ""
    var destinationPlacePicked = ""
    var numOfTravellersPicked = ""
    
    //Used for loading screen animation when calculate is pressed
    var myTrip: Trip?
    var mySettings: Settings?
    var loadingScreenHappen = false //used to determine if loading screen completed so you navigate to next screen
    
    //all pickers will contain a single component
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //determine number of rows that a picker needs to display its elements
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
    
    //determine title for currently displayed component
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
            return("Error in picker")
        }
    }
    
    //respont to user selecting a new row
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
            print("Error in picker")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if loadingScreenHappen {
            tabBarController?.selectedIndex = 1
            loadingScreenHappen = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //picker related setup
        originPlacePicked = ""
        destinationPlacePicked = ""
        numOfTravellersPicked = ""
        
        //create empty settings if they are not created yet
        if mySettings == nil{
            mySettings = Settings(budgetSet: false, budgetAmount: 0.0, directFlightOnly: false, culturalActivitiesPrefference: 0, outdoorsActivitiesPrefference: 0, nightlifeActivitiesPrefference: 0, hotelRaiting: 3, amenitiesPrefferenceSelected: [String](), activitiesPrefferenceSelected: [String]())
        }
       
        self.numTravellersPicker.dataSource = self;
        self.numTravellersPicker.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     * This function validates data in Origin and Destination pickers
     * @param origin - origin place name (city or country)
     * @param destination - destination place name (city or country)
     * @return true if input is valid, false otherwise
     */
    func validateOriginDestinationPickers(origin originPlacePicked: String, destination destinationPlacePicked: String) -> Bool{
        guard originPlacePicked.count > 1 else {
            let alertController = UIAlertController(title: "Error", message: "Origin not selected.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        guard destinationPlacePicked.count > 1 else {
            let alertController = UIAlertController(title: "Error", message: "Destination not selected.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return false
            
        }
        
        //Check that the user didn't select the same destination and origin
        guard originPlacePicked != destinationPlacePicked else {
            let alertController = UIAlertController(title: "Error", message: "Origin and destination must be differnt.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    /*
     * This function validates data in Departere and Return Date pickers
     * @param departureDate - departure date
     * @param returnDate - return date
     * @param currentDate - todays date
     * @return true if input is valid, false otherwise
     */
    func validateDepartureReturnDatePickers(departureDate departure_date_str: String, returnDate return_date_str: String, currentDate current_date_str: String) ->Bool{
        
        //Check that departure date is in the future
        guard departure_date_str > current_date_str else {
            let alertController = UIAlertController(title: "Error", message: "Departure date needs to be in the future.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        //Check that departure date is not greater than return date
        guard departure_date_str < return_date_str else {
            let alertController = UIAlertController(title: "Error", message: "Return date must be past departure date.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    /*
    * Steps after unwind from loading screen view controller
    *
    * @param segue - segue to unwind from
    */
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller Successful")
        
        //Get generated trip structure from LoadingScreenViewController
        guard let sourceViewController = segue.source as? LoadingScreenViewController else {
            print("Unwind from loading screen view controller error")
            return
        }
        let loadWasTimeout = sourceViewController.wasTimeout
        if loadWasTimeout == false {
            myTrip = sourceViewController.newTrip
            
            //Pass myTrip variable to cost tab
            let myCostTab = self.tabBarController?.viewControllers![2] as! CostViewController
            myCostTab.myTrip = myTrip
            
            //Pass data to aboutTab
            /*
            let aboutTab = self.tabBarController?.viewControllers![3] as! AboutViewController
            aboutTab.countryName = destinationPlacePicked
            */
            
            //Pass data to ActivitiesTab
            let activitiesTab = self.tabBarController?.viewControllers![1].childViewControllers[0] as! ActivitiesTabTableViewController
            
            activitiesTab.city = destinationPlacePicked
            activitiesTab.selectedArray = [false, false, false, false, false, false, false, false, false]
            activitiesTab.totalCost = 0.0
            activitiesTab.myTrip = myTrip
            loadingScreenHappen = true
        }
        //Reset the variable to tell if there was timeout
        else {
            sourceViewController.wasTimeout = false
        }
    }
    
    /**
    * determines whether or not loading screen segue should happen
    *
    * @param identifier - identifier of segue
    * @param sender - who is sending segue
    */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //Validating user input before button action
        //Get time values and change format of dates
        if identifier == "toSettingsSegue" {
            return true
        } else {
            let current_date = Date()
            let departure_date = departureDatePicker.date
            let return_date = returnDatePicker.date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let departure_date_str: String = formatter.string(from: departure_date)
            let return_date_str: String = formatter.string(from: return_date)
            let current_date_str: String = formatter.string(from: current_date)
        
            //check that user picked a country, correct dates, etc
            if !validateOriginDestinationPickers(origin: originPlacePicked, destination: destinationPlacePicked) ||
            !validateDepartureReturnDatePickers(departureDate: departure_date_str, returnDate: return_date_str, currentDate:    current_date_str){
                return false
            }
            return true
        }
    }
    
    /**
    * Used to pass data through segues - specifically to navigate to loading screen view controller
    *
    * @param segue - segue to go to
    * @param sender - who is sending segue
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSettingsSegue" {
            let settingsTableViewController = segue.destination.childViewControllers[0] as! SettingsTableViewController
            settingsTableViewController.mySettings = mySettings
        } else {
            guard let destinationVC = segue.destination as? LoadingScreenViewController else {
                print("Error seguing to loading screen")
                return
            }
            
            //Create and set date values
            let current_date = Date()
            let departure_date = departureDatePicker.date
            let return_date = returnDatePicker.date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let departure_date_str: String = formatter.string(from: departure_date)
            let return_date_str: String = formatter.string(from: return_date)
            let current_date_str: String = formatter.string(from: current_date)
            
            //Pass data needed for api calls to loadingScreenViewController
            //Pass Cost Data
            destinationVC.originLocation = originPlacePicked
            destinationVC.destinationLocation = destinationPlacePicked
            destinationVC.departureDate = departure_date_str
            destinationVC.returnDate = return_date_str
            destinationVC.numTravellers = numOfTravellersPicked
            let diffInDays = Calendar.current.dateComponents([.day], from: departure_date, to: return_date).day
            destinationVC.numDays = diffInDays!
            destinationVC.reportRunDate = current_date_str
            destinationVC.settingsObj = mySettings
        }
    }
    
    @IBAction func unwindToNewTripViewController(segue: UIStoryboardSegue) {
        guard let source = segue.source as? SettingsTableViewController,
            let mySettings = source.mySettings else { return }
        //TODO: add mySettings to myTrip and implement its saving
        
            
    }
}

