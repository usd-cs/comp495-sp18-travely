//
//  ActivitiesTabTableViewController.swift
//  travely
//
//  Created by Alexandra Leonidova on 4/4/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

class ActivitiesTabTableViewController: UITableViewController {

    var city = ""
    var activities: Activities?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // design
        let backgroundImage = UIImage(named: "gradient_background.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        if city.count < 1{
            activities = nil
            return
        } else {
            activities = Activities(cityName: city)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        print(city)
        if city.count < 1{
            activities = nil
            return
        } else {
            activities = Activities(cityName: city)
        }
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        if city.count < 1{
            activities = nil
            return
        } else {
            activities = Activities(cityName: city)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard activities != nil else { return 0 }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard activities != nil else { return 0 }
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        
        guard let activities = activities else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            return cell
        }
        
        var dataSource: [String: String] = [:]
        switch indexPath.section{
        case 0:
            dataSource = activities.culturalActivities[indexPath.row]
        case 1:
            dataSource = activities.outdoorsActivities[indexPath.row]
        case 2:
            dataSource = activities.nightlifeActivities[indexPath.row]
        default:
            fatalError("Error configuring cess in Activities Tab")
        }
        
        // Configure the cell
        cell.textLabel?.text = dataSource["name"]
        if let price = Int(dataSource["price"]!){
            if price > 0{
                cell.detailTextLabel?.text = "$\(price)"
            } else {
                cell.detailTextLabel?.text = "FREE"
            }
        } else {
            cell.detailTextLabel?.text = "???"
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Cultural Activities"
        case 1:
            return "Outdoors Activities"
        case 2:
            return "Nightlife Activities"
        default:
            return "Other Activities"
        }
    }
    
    
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewActivityDetailSegue" {
            let activityDetailsViewController = segue.destination as! ActivityDetailsViewController
            let indexPath = tableView.indexPathForSelectedRow!
            var selectedActivity: [String: String] = [:]
            switch indexPath.section{
            case 0:
                selectedActivity = (activities?.culturalActivities[indexPath.row])!
            case 1:
                selectedActivity = (activities?.outdoorsActivities[indexPath.row])!
            case 2:
                selectedActivity = (activities?.nightlifeActivities[indexPath.row])!
            default:
                return
            }
            activityDetailsViewController.selectedActivity = selectedActivity
        }
    }
}
