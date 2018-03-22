//
//  CostViewController.swift
//  travely
//
//  Created by Alexandra Leonidova on 3/11/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit
import Charts

class CostViewController: UIViewController {

    var originLocation = ""
    var destinationLocation = ""
    var departureDate  = ""
    var returnDate = ""
    var numTravellers = ""
    
    
    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let expenses = ["Transportation", "Accomodations", "Food", "Miscellaneous"]
        let costOfExpense = [999.99, 999.99, 999.99, 999.99]
        setChart(dataPoints: expenses, values: costOfExpense)
        print("result " + String(getFlightMinCost()))
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
    * This function will call the Amadeus Flights Airfare API and retrieve lowest cost information
    * return -1 on error
    *
    * NOTE: Not finished. Do not modify yet
    */
    func getFlightMinCost() -> Double {
        guard originLocation != "", destinationLocation != "" else {
            print("Location values not set when trying to receive flight min cost")
            return -1
        }
        
        guard returnDate != "" else {
            print("Return date value not set when trying to receive flight min cost")
            return -1
        }
        
        var origin_IATA = ""
        var destination_IATA = ""
        
        //TODO: Eventually replace this IATA code method with calling API to retrieve IATA codes
        if originLocation == "New York" {
            origin_IATA = "JFK"
        } else if originLocation == "San Diego" {
            origin_IATA = "SAN"
        } else if originLocation == "Rome" {
            origin_IATA = "FCO"
        } else {
            print("Error determining IATA Code for flights API")
            return -1
        }
        
        if destinationLocation == "New York" {
            destination_IATA = "JFK"
        } else if destinationLocation == "San Diego" {
            destination_IATA = "SAN"
        } else if destinationLocation == "Rome" {
            destination_IATA = "FCO"
        } else {
            print("Error determining IATA Code for flights API")
            return -1
        }
        
        let headers = [
            "Cache-Control": "no-cache",
            "Postman-Token": "6127903e-057b-463d-b201-3a9ed5c61041"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=" + AMADEUSFLIGHTAPIKEY + "&origin=" + origin_IATA + "&destination=" + destination_IATA + "&departure_date=" + departureDate)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Error calling flight api")
            } else {
                let httpResponse = response as? HTTPURLResponse
                guard httpResponse?.statusCode == 200 else {
                    print("Error - API Flight statusCode is not 200")
                    return
                }
                
                print(httpResponse ?? "httpResponse default value since httpResponse didn't have value")
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                
                //TODO: Alexandra's issue - parse JSON and return min cost
            }
        })
        dataTask.resume()
        
        
        
        return 1
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
