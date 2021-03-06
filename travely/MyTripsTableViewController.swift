//
//  MyTripsTableViewController.swift
//  travely
//
//  Created by Spencer Mcdonald on 4/2/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit
import os.log

class MyTripsTableViewController: UITableViewController {
    
    var trips = [Trip]()
    var titleToDisplay = ""
    override func viewWillAppear(_ animated: Bool) {
      
        //Load and reload trips when navigated to this page
        if let saved = loadTrips() {
            trips = saved
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // design
        let backgroundImage = UIImage(named: "gradient_background.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTripsTableViewCell", for: indexPath) as? MyTripsTableViewCell else {
            fatalError("Cell for MyTrips not an instance of MyTripsTableView Controller")
        }
        
        // Configure the cell...
        
        let trip = trips[indexPath.row]
        cell.tripLabel.text = trip.tripName
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            trips.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        //Save trips after editing
        saveTrips()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SavedTripDetailsSegue" {
            let destinationVC = segue.destination as! SavedTripDetailsViewController
            
            //Send chosen trip details to destination segue
            destinationVC.my_trip = trips[tableView.indexPathForSelectedRow!.row]
        }
        
    }
    
    
    func saveTrips(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(trips, toFile: Trip.ArchiveURL.path)
        if isSuccessfulSave{
            os_log("Trips successfully save",log: OSLog.default,type:.debug)
        }
        else{
            os_log("Failed to save trips", log: OSLog.default, type: .debug)
        }
    }
    
    private func loadTrips() -> [Trip]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Trip.ArchiveURL.path) as? [Trip]
    }
    
}

