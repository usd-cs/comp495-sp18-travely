//
//  SettingsTableViewController.swift
//  travely
//
//  Created by Alexandra Leonidova on 4/22/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var mySettings: Settings?
    
    //Amenity Connections
    @IBOutlet weak var babySittingAmenity: UISwitch!
    @IBOutlet weak var banquetAmenity: UISwitch!
    @IBOutlet weak var coffeeShopAmenity: UISwitch!
    @IBOutlet weak var conciergeAmenity: UISwitch!
    @IBOutlet weak var freeInternetAmenity: UISwitch!
    @IBOutlet weak var gymAmenity: UISwitch!
    @IBOutlet weak var jacuzziAmenity: UISwitch!
    @IBOutlet weak var laundryServiceAmenity: UISwitch!
    @IBOutlet weak var poolAmenity: UISwitch!
    @IBOutlet weak var restaurantAmenity: UISwitch!
    
    @IBAction func budgetTextFieldValueChanged(_ sender: UITextField) {
        if let budget = Double(budgetTextField.text ?? "0"){
            budgetTextField.text = String(budget)
        } else {
            //display alert to user
            let alertController = UIAlertController(title: "Invalid Budget:", message: "Budget must be a number", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok.", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            budgetTextField.text = "0"
        }
    }
    @IBAction func budgetTextPrimary(_ sender: UITextField) {
        if let budget = Double(budgetTextField.text ?? "0"){
            budgetTextField.text = String(budget)
        } else {
            //display alert to user
            let alertController = UIAlertController(title: "Invalid Budget:", message: "Budget must be a number", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok.", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            budgetTextField.text = "0"
        }
    }
    @IBAction func budgetTextldPrimaryAction(_ sender: UITextField) {
        if let budget = Double(budgetTextField.text ?? "0"){
            budgetTextField.text = String(budget)
        } else {
            //display alert to user
            let alertController = UIAlertController(title: "Invalid Budget:", message: "Budget must be a number", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok.", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            budgetTextField.text = "0"
        }
    }
  
    @IBOutlet var ratingButtons: [UIButton]!
    
    @IBAction func ratingSelected(_ sender: UIButton) {
        let tag = sender.tag
        //iterate through each star button
        for button in ratingButtons{
            //fill the star if it is less than selected star
            if button.tag <= tag{
                button.setTitle("★", for: .normal)
            }
            else{
                button.setTitle("☆", for: .normal)
            }
        }
    }
    
    /*
     * This function saves data from settings page to mySettings object
     */
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        mySettings!.budgetSet = budgetSwitch.isOn
        if mySettings!.budgetSet{
            if let budget = Double(budgetTextField.text ?? "0"){
                mySettings!.budgetAmount = budget
            } else {
                mySettings!.budgetAmount = 0
            }
        }
        
        
        //Create Amenities variable to store in Settings object
        mySettings?.amenitiesPrefferenceSelected = generateAmenitiesData()
    
        performSegue(withIdentifier: "saveSettingsSegue", sender: self)
    }
    
    func generateAmenitiesData() -> [String] {
        var my_amenities = [String]()
        
        if babySittingAmenity.isOn == true {
            my_amenities.append("BABY_SITTING")
        }
        
        return my_amenities
    }
    
    @IBOutlet weak var budgetSwitch: UISwitch!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var budgetAmountCell: UITableViewCell!
    
    @IBAction func budgetSwitchPressed(_ sender: UISwitch) {
        if budgetSwitch.isOn{
            budgetAmountCell.isHidden = false
        } else {
            budgetAmountCell.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //If there is a settings variable then set values in page to previously selected values
        if mySettings != nil {
            if (mySettings?.amenitiesPrefferenceSelected.contains("BABY_SITTING"))! {
                babySittingAmenity.setOn(true, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard mySettings != nil else{
            fatalError("Didnt recieve mySettings object in SettingsTableViewController")
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SettingsTableViewController.saveButtonPressed(_:)))
        
        assignInitialValues()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     * This function sets up the initial setting view based on accepted Settings Object
     */
    func assignInitialValues(){
        //TODO: team, extract your values here\
        
        //budget section
        budgetSwitch.isOn = mySettings!.budgetSet
        let currBudget: String = String(describing: mySettings?.budgetAmount)
        if currBudget != "nil" {
            budgetTextField.text = currBudget
        } else {
            budgetTextField.text = "0"
        }
        
        if budgetSwitch.isOn{
            budgetAmountCell.isHidden = false
        } else {
            budgetAmountCell.isHidden = true
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 10
        default:
            return 0
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
