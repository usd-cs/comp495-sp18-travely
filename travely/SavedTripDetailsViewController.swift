//
//  SavedTripDetailsViewController.swift
//  travely
//
//  Created by Matt on 3/20/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit
import Charts

class SavedTripDetailsViewController: UIViewController {
    var my_trip: Trip?
    
    //Outlet for the chart
    @IBOutlet weak var pieChartView: PieChartView!
    //Outlet for the email trip button
    @IBAction func emailButton(_ sender: Any) {
        print("Email button clicked")
    }
    //Outlet for the trip name
    @IBOutlet weak var tripNameField: UILabel!
    //Outlet for the trip price
    @IBOutlet weak var totalPriceField: UILabel!
    //Outlet for the view country information button
    @IBAction func viewCountryInformation(_ sender: Any) {
        print("view country info button clicked")
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
}


