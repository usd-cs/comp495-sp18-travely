//
//  ActivitiesTabTableViewController.swift
//  travely
//
//  Created by Alexandra Leonidova on 4/4/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

class ActivitiesTabTableViewController: UITableViewController, ActivityCellDelegate {
    
    var city = ""
    var activities: Activities?
    var selectedArray = [false, false, false, false, false, false, false, false, false]
    var totalCost = 0.0
    var myTrip: Trip?
    
    func checkmarkTapped(sender: ActivityTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender){
            let index = indexPath.section * 3 + indexPath.row
            selectedArray[index] = !selectedArray[index]
            
            guard let activities = activities else {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                return
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
                fatalError("Error configuring cell in Activities Tab")
            }
            if selectedArray[index]{
                var currPrice: Double = 0
                if let price = Double(dataSource["price"]!){
                    totalCost += price
                    currPrice = price
                }
                myTrip?.activityList.append(Activity(name: dataSource["name"]!, price: currPrice)!)
                
                activities.addActivity(name: dataSource["name"]!, price: dataSource["price"]!)
            } else {
                if let price = Double(dataSource["price"]!){
                    totalCost -= price
                }
                activities.removeActivity(name: dataSource["name"]!)
                myTrip?.activityList = (myTrip?.activityList.filter { $0.name != dataSource["name"]! })!

            }
            print("checkmarkTapped : \(totalCost) , \(activities.totalPrice)")
            
            let myCostTab = self.tabBarController?.viewControllers![2] as! CostViewController
            myCostTab.activitiesCostAccepted = totalCost
            myCostTab.myTrip = myTrip
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // design
        let backgroundImage = UIImage(named: "gradient_background.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        //TODO my =Trip check
        
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
        print("viewWillAppear")
        if city.count < 1{
            activities = nil
            return
        } else {
            activities = Activities(cityName: city)
        }
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Pass myTrip variable to cost tab
        let myCostTab = self.tabBarController?.viewControllers![2] as! CostViewController
        myCostTab.activitiesCostAccepted = totalCost
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
        //let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell") as? ActivityTableViewCell
            else{
                fatalError("Could not dequeue a cell")
        }
        
        cell.delegate = self
        
        guard let activities = activities else {
            cell.titleLabel?.text = ""
            cell.priceLabel?.text = ""
            let image = UIImage(named: "Unhecked")
            cell.checkedButton?.setBackgroundImage(image, for: .normal)
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
        cell.titleLabel?.text = dataSource["name"]
        if let price = Int(dataSource["price"]!){
            if price > 0{
                cell.priceLabel?.text = "$\(price)"
            } else {
                cell.priceLabel?.text = "FREE"
            }
        } else {
            cell.priceLabel?.text = "???"
        }
        
        let index = indexPath.section * 3 + indexPath.row
        if selectedArray[index]{
            let image = UIImage(named: "Checked")
            cell.checkedButton.setBackgroundImage(image, for: .normal)
        } else {
            let image = UIImage(named: "Unchecked")
            cell.checkedButton.setBackgroundImage(image, for: .normal)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
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
