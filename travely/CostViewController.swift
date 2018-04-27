//
//  CostViewController.swift
//  trave.ly
//
//  Created by Alexandra Leonidova on 3/11/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit
import Charts

class CostViewController: UIViewController {
    var myTrip: Trip?
    var activitiesCostAccepted: Double?
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var airfareCostLabel: UILabel!
    @IBOutlet weak var hotelCostLabel: UILabel!
    @IBOutlet weak var publicTranportationLabel: UILabel!
    @IBOutlet weak var activitiesCostLabel: UILabel!
    @IBOutlet weak var foodCostLabel: UILabel!
    
    var minFlightCost: Double?
    var minHotelCost: Double?
    var totalCost: Double?
    var foodCost: Double?
    var activitiesCost: Double?
    var publicTransportationCost: Double?
    var numberOfTravellers: Double?
    var totalTransportationCost: Double?
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let myTripsTab = self.tabBarController?.viewControllers![3].childViewControllers[0] as! MyTripsTableViewController
        myTripsTab.trips += [myTrip!]
        myTripsTab.saveTrips()
    }
    
    //This function is called everytime the cost tab is visible
    override func viewWillAppear(_ animated: Bool) {
        if myTrip == nil {
            minFlightCost = 0
            minHotelCost = 0
            totalCost = 0
            foodCost = 0
            activitiesCost = 0
            publicTransportationCost = 0
            numberOfTravellers = 0
            totalTransportationCost = 0
            
            zeroPrices()
        } else {
            minFlightCost = myTrip!.tripAirfareCost
            minHotelCost = myTrip!.tripHotelCost
            totalCost = myTrip!.tripTotalCost
            foodCost = myTrip!.foodCost
            //activitiesCost = myTrip!.activitiesCost
            publicTransportationCost = myTrip!.tripPublicTransportationCost
            numberOfTravellers = myTrip!.numberOfTravellers
            if let activitiesCostAccepted = activitiesCostAccepted, let numberOfTravellers = numberOfTravellers{
                activitiesCost = activitiesCostAccepted * numberOfTravellers
                totalCost = totalCost! + activitiesCost!
            } else {
                activitiesCost = 0.0
            }
            totalTransportationCost = myTrip!.tripPublicTransportationCost + myTrip!.tripAirfareCost
            setLabelsWithData()
        }
    }
    
    //This function uses the existing or newly calculated information to populate the labels and chart
    func setLabelsWithData() {
        let expenses = ["Transportation", "Accomodations", "Food", "Miscellaneous"]
        let costOfExpense = [totalTransportationCost, minHotelCost, foodCost, activitiesCost]
        setChart(dataPoints: expenses, values: costOfExpense as! [Double])
        totalCostLabel.text = "$" + String(describing: totalCost!)
        airfareCostLabel.text = "$" + String(describing: minFlightCost!)
        hotelCostLabel.text = "$" + String(describing: minHotelCost!)
        publicTranportationLabel.text = "$" + String(describing: publicTransportationCost!)
        activitiesCostLabel.text = "$" + String(describing: activitiesCost!)
        foodCostLabel.text = "$" + String(describing: foodCost!)
    }
    
    //This function sets the prices to the default $0
    func zeroPrices() {
        totalCostLabel.text = "$0"
        airfareCostLabel.text = "$0"
        hotelCostLabel.text = "$0"
        publicTranportationLabel.text = "$0"
        activitiesCostLabel.text = "$0"
        foodCostLabel.text = "$0"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    /*
     *   This function will return the average price for the hotels and air travel
     *   Parameters: An array of doubles, all of the prices received from the API
     *   Returns: the average cost of all of prices, if returns -1 that means the array was empty
     */
    func findDataAverage(dataCosts: [Double]) -> Double{
        if dataCosts.count == 0 {
            return -1
        }
        var averageCost = 0.0;
        var totalCost = 0.0;
        for i in 0...(dataCosts.count-1) {
            totalCost = totalCost + dataCosts[i]
        }
        averageCost = totalCost/Double(dataCosts.count)
        return averageCost
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


