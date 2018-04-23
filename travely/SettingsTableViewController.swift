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
    
    /*
     * This function saves data from settings page to mySettings object
     */
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
