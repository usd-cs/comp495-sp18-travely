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

class SavedTripDetailsViewController: UIViewController, MFMailComposeViewControllerDelegate{
    var my_trip: Trip?
    
    var countryName = ""
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryName = "Beijing"
        populateWithData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //This function will configure the Mail VC by setting this VC as its delegate
    //as well as providing who the recipient is and message body
    func configureMailController() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        //creates subject line in form of ORG to DEST
        let subject : String = originLocation.text!+" to "+destinationLocation.text!+" Trip Details"
        let body : String =
        "<div> <h3>Trip Details</h3> <div>Origin:</div><div>Destination:</div><div>Departure Date:</div><div>Return Date:</div><h3>Cost Breakdown</h3><div>Transportation:</div><div>Accommodation:</div><div>Food:</div><div>Activities:</div></div>"
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


