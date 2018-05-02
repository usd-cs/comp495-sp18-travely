//
//  SavedTripDetailsViewController.swift
//  travely
//
//  Created by Matt on 3/20/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit
import Charts
import MessageUI

class SavedTripDetailsViewController: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    var my_trip: Trip?
    
    var countryName = ""
    
    //This variable is to test the hotel rating label
    var numHotelStars: Int?
    
    //Outlet for the chart
    @IBOutlet weak var pieChartView: PieChartView!
    //Outlet for the email trip button
    @IBAction func emailButton(_ sender: Any) {
        let mailVC = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailVC, animated: true, completion: nil)
        }
        else{
            showMailError()
        }
    }
    //Outlet for the trip name
    @IBOutlet weak var tripNameField: UILabel!
    //Outlet for the trip price
    @IBOutlet weak var totalPriceField: UILabel!
    //Outlet for the view country information button
    @IBAction func viewCountryInformation(_ sender: Any) {
        
    }
    //Outlet for the origin location
    @IBOutlet weak var originLocation: UILabel!
    //Outlet for the destination location
    @IBOutlet weak var destinationLocation: UILabel!
    //Outlet for the departure date
    @IBOutlet weak var departureDate: UILabel!
    //Outlet for the return date
    @IBOutlet weak var returnDate: UILabel!
    //Outlet for airfare cost
    @IBOutlet weak var airfareCostLabel: UILabel!
    //Outlet for hotel cost
    @IBOutlet weak var hotelCostLabel: UILabel!
    //Outlet for food cost
    @IBOutlet weak var foodCostLabel: UILabel!
    //Outlet for activities cost
    @IBOutlet weak var activitiesCostLabel: UILabel!
    //Outlet for the label of the hotel rating
    @IBOutlet weak var hotelRating: UILabel!
    //Outlets for the hotel rating (number of stars)
    @IBOutlet weak var hotelRatingLabel: UILabel!
    //Outlet for the filtered ameninities
    @IBOutlet weak var filteredAmenitiesLabel: UILabel!
    
    
    @IBOutlet weak var activityTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get the hotel rating from the trip
        numHotelStars = my_trip?.settingsObject.hotelRaiting
        if numHotelStars == 0 {
            hotelRating.isHidden = true
            hotelRatingLabel.isHidden = true
        }
        countryName = "Beijing"
        populateWithData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // table view related
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard my_trip != nil || my_trip!.activityList.count > 0 else{
            return 1
        }
        var return_val = my_trip!.activityList.count
        print(return_val)
        return my_trip!.activityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell") else {
            fatalError("Could not dequeue a cell")
        }
        guard let activityList = my_trip?.activityList else {
            fatalError("Could not get activity list on Trip Details")
        }
        
        if activityList.count == 0{
            cell.textLabel?.text = "No Activities Selected"
            cell.detailTextLabel?.text = ""
        }
        cell.textLabel?.text = activityList[indexPath.row].name
        if activityList[indexPath.row].price > 0{
            cell.detailTextLabel?.text = "$\(String(activityList[indexPath.row].price))"
        } else {
            cell.detailTextLabel?.text = "FREE"
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return cell
    }
    
    //TODO: declare a func that takes in the data and preps the pie chart
    func setChart(dataPoints: [String], values: [Double]){
        var pieDataEntry: [PieChartDataEntry] = []
        //for-loop below creates data entries for each of the values
        for i in 0...(dataPoints.count-1){
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            pieDataEntry.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(values: pieDataEntry, label: "Total Cost")
        pieChartDataSet.colors = ChartColorTemplates.colorful()
        pieChartDataSet.label = "Total Cost Breakdown"
        pieChartDataSet.entryLabelFont = NSUIFont(name: "Arial", size: CGFloat(integerLiteral: 10))
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        pieChartView.data = pieChartData
    }
    
    func populateWithData(){
        let expenses = ["Transportation", "Accomodations", "Food", "Miscellaneous"]
        let costOfExpense = [1700.00, 1500.00, 300.00, 500.00]
        setChart(dataPoints: expenses, values: costOfExpense)
        tripNameField.text = my_trip?.tripName
        originLocation.text = my_trip?.originLocation
        destinationLocation.text = my_trip?.destinationLocation
        departureDate.text = my_trip?.departureDate
        returnDate.text = my_trip?.returnDate
        airfareCostLabel.text = "$" + String(describing: my_trip!.tripAirfareCost)
        hotelCostLabel.text = "$" + String(describing: my_trip!.tripHotelCost)
        foodCostLabel.text = "$" + String(describing: my_trip!.foodCost)
        activitiesCostLabel.text = "$" + String(describing: my_trip!.activitiesCost)
        totalPriceField.text = "$" + String(describing: my_trip!.tripTotalCost)
        hotelRatingLabel.text = String(describing: numHotelStars!) + " stars"
        if my_trip != nil {
            filteredAmenitiesLabel.text = prepareAmenitiesStr()
        }
    }
    
    //Translates amenity code into human readible text and returns human readible text
    func translateAmenityCode(code: String) -> String {
        if code == "BABY_SITTING" {
            return "Baby Sitting"
        }
        
        if code == "BANQUET_FACILITIES" {
            return "Banquet Facilities"
        }
        
        if code == "COFFEE_SHOP" {
            return "Coffee Shop"
        }
        
        if code == "CONCIERGE_DESK" {
            return "Concierge"
        }
        
        if code == "FREE_HIGH_SPEED_INTERNET" {
            return "Free Internet"
        }
        
        if code == "GYM" {
            return "Gym"
        }
        
        if code == "JACUZZI" {
            return "Jacuzzi"
        }
        
        if code == "LAUNDRY_SERVICE" {
            return "Laundry Service"
        }
        
        if code == "POOL" {
            return "Pool"
        }
        
        if code == "RESTAURANT" {
            return "Restaurant"
        }
        
        //Should never happen
        return "Error"
    }
    
    //MARK:Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toAboutTab" {
            // Create a new variable to store the instance of searchResultsViewController
            let destinationVC = segue.destination as! AboutViewController
            destinationVC.countryName = countryName
        }
    }
    
    func prepareAmenitiesStr() -> String {
        var amenities_str = ""
        if (my_trip?.settingsObject.amenitiesPrefferenceSelected.isEmpty)! {
            amenities_str = "Amenities Filtered: None"
        } else {
            amenities_str = "Amenities Filtered: "
            for amenity in (my_trip?.settingsObject.amenitiesPrefferenceSelected)! {
                amenities_str += translateAmenityCode(code: amenity) + ", "
            }
            amenities_str.remove(at: amenities_str.index(before: amenities_str.endIndex))
            amenities_str.remove(at: amenities_str.index(before: amenities_str.endIndex))
        }
        
        return amenities_str
    }
    
    //This function will configure the Mail VC by setting this VC as its delegate
    //as well as providing who the recipient is and message body
    func configureMailController() -> MFMailComposeViewController{
        
        let mailComposeVC = MFMailComposeViewController()
        //creates subject line in form of ORG to DEST
        let subject : String = originLocation.text!+" to "+destinationLocation.text!+" Trip Details"

        var activitiesHTML = ""
        if my_trip!.activityList.count > 0{
            activitiesHTML += "<ul> "
            for activity in (my_trip?.activityList)!
            {
                if activity.price > 0{
                    activitiesHTML += "<li>\(activity.name) : $\(activity.price)</li> "
                } else {
                    activitiesHTML += "<li>\(activity.name) : FREE</li>"
                }
            }
            activitiesHTML += " </ul>"
        }
        let body : String = """
        <div style="background-color:lightcyan;">
            <h3>Trip Details</h3>
                <div>Origin: \(originLocation.text!)</div>
                <div>Destination: \(destinationLocation.text!)</div>
                <div>Departure Date: \(departureDate.text!)</div>
                <div>Return Date: \(returnDate.text!)</div>
            <h3>Cost Breakdown</h3>
                <div>Transportation: \(airfareCostLabel.text!)</div>
                <div>Accommodation: \(hotelCostLabel.text!)</div>
                <div>Hotel Rating: \(hotelRatingLabel.text!)</div>
                <div>Filtered Amenities: \(filteredAmenitiesLabel.text!)</div>
                <div>Food: \(foodCostLabel.text!)</div>
                <div>Activities: \(activitiesCostLabel.text!)</div>
                    <div>\(activitiesHTML)</div>
                <div>Total Cost: \(totalPriceField.text!)</div></div>
        """
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody(body, isHTML: true)
        return mailComposeVC
    }
    
    //Will handle if there was an error creating an email
    func showMailError(){
        let sendMailAlert = UIAlertController(title: "Could not send mail.", message: "Your device couldn't send mail.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailAlert.addAction(dismiss)
        self.present(sendMailAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}


