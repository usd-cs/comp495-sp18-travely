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
    
    @IBOutlet weak var hotelRating: UILabel!
    @IBOutlet weak var hotelRatingLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var minFlightCost: Double?
    var minHotelCost: Double?
    var totalCost: Double?
    var foodCost: Double?
    var activitiesCost: Double?
    var publicTransportationCost: Double?
    var numberOfTravellers: Double?
    var totalTransportationCost: Double?
    //This variable is to test the hotel rating labels
    var numHotelStars: Int?
    //This variable is to test the budget functionality
    var tripBudget: Double?
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let myTripsTab = self.tabBarController?.viewControllers![3].childViewControllers[0] as! MyTripsTableViewController
        myTripsTab.trips += [myTrip!]
        myTripsTab.saveTrips()
    }
    
    //This function is called everytime the cost tab is visible
    override func viewWillAppear(_ animated: Bool) {
        //This line is just to test the hotel rating labels
        numHotelStars = 3
        //This line is just to test the budget functionality before the settings has been implemented
        tripBudget = 100.0
        
        if myTrip == nil {
            minFlightCost = 0
            minHotelCost = 0
            totalCost = 0
            foodCost = 0
            activitiesCost = 0
            publicTransportationCost = 0
            numberOfTravellers = 0
            totalTransportationCost = 0
            hotelRating.isHidden = true
            hotelRatingLabel.isHidden = true
            saveButton.isHidden = true
            zeroPrices()
        } else {
            saveButton.isHidden = false
            minFlightCost = myTrip!.tripAirfareCost
            numberOfTravellers = myTrip!.numberOfTravellers
            minHotelCost = getHotelCost(myTrip: myTrip!, numOfTravellers: numberOfTravellers!)//myTrip!.tripHotelCost
            totalCost = myTrip!.tripTotalCost
            foodCost = myTrip!.foodCost
            //activitiesCost = myTrip!.activitiesCost
            publicTransportationCost = myTrip!.tripPublicTransportationCost
            if let activitiesCostAccepted = activitiesCostAccepted, let numberOfTravellers = numberOfTravellers{
                activitiesCost = activitiesCostAccepted * numberOfTravellers
                totalCost = totalCost! + activitiesCost!
            } else {
                activitiesCost = 0.0
            }
            totalTransportationCost = myTrip!.tripPublicTransportationCost + myTrip!.tripAirfareCost
            hotelRating.isHidden = false
            hotelRatingLabel.isHidden = false
            setLabelsWithData()
            
            let budget = Double(tripBudget!)
            let cost = Double(totalCost!)
            if budget < cost {
                costOverBudget()
                totalCostLabel.textColor = UIColor.red
            }
        }
    }
    
    /*
     *  This function will send an error message if the user is over budget
     */
    func costOverBudget() {
        if Int(numberOfTravellers!)%2 == 0 {
             let alertController = UIAlertController(title: "Overbudget", message: "The trip that you have calculated is overbudget. Here are some recommendations:\nSet the start date further in the future,\nReduce the number of days,\nRemove a traveller,\nRemove costly activities,\nAdd more free activities", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Ok", style: .default, handler:  nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
             let alertController = UIAlertController(title: "Overbudget", message: "The trip that you have calculated is overbudget. Here are some recommendations:\nSet the start date further in the future,\nReduce the number of days,\nAdd another traveller and share hotel rooms,\nRemove costly activities,\nAdd more free activities", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title:"Ok", style: .default, handler:  nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //function that will return the minimum hotel cost
    //will take in myTrip to get the data stored as well as numOfTravellers
    //looked at some sites online and most you can fit in one room is typically 2 people and in some up to three
    //so fnc is: 2people=1room, 4people=2rooms, 6people=3rooms etc etc
    //3people = 1 room (three), 5people=2 rooms (three two), 7people = 3 rooms(two two three), 9people = 3rooms(three three three)
    func getHotelCost(myTrip : Trip, numOfTravellers : Double) -> Double{
        //will handle all even num of travellers and single room that fits 1,3 travellers
        if(Int(numOfTravellers)%2 == 0 || numOfTravellers == 1 || numOfTravellers == 3){
            return (numOfTravellers/2)*myTrip.tripHotelCost
        }
        //will handle 9 and 7 travellers
        else if (numOfTravellers == 7 || numOfTravellers == 9){
            return 3.0*myTrip.tripHotelCost
        }
        //will handle 5 travellers
        else{
            return 2.0*myTrip.tripHotelCost
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
        hotelRatingLabel.text = String(describing: numHotelStars!) + " stars"
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


