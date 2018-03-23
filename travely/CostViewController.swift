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
    
    var hotelCallDone = false
    var hotelCallError = false
    var hotelData: Data?
    
    var calculateButtonWasPressed = false
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        if calculateButtonWasPressed == true {
            var minHotelCost = getHotelMinCost()
        }
        calculateButtonWasPressed = false
        
        // Do any additional setup after loading the view.
        let expenses = ["Transportation", "Accomodations", "Food", "Miscellaneous"]
        let costOfExpense = [999.99, 999.99, 999.99, 999.99]
        setChart(dataPoints: expenses, values: costOfExpense)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    *
    * NOTE: Not finished. Do not modify yet
    */
    func getFlightMinCost() -> Double {
        
        let headers = [
            "Cache-Control": "no-cache",
            "Postman-Token": "6127903e-057b-463d-b201-3a9ed5c61041"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=" + AMADEUSFLIGHTAPIKEY + "&origin=BOS&destination=LON&departure_date=2018-06-25")! as URL,
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
                print(httpResponse ?? "httpResponse default value since httpResponse didn't have value")
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            }
        })
        
        
        dataTask.resume()
        
        return 1.0
    }
    
    /*
     * This function will call the hotel API
     * Returns -1 to signify that there were some invalid parameters
     */
    func getHotelMinCost() -> Double {
        //Check for errors in passed data
        guard destinationLocation != "" else {
            print("Error in passed destinationLocation")
            return -1
        }
        guard departureDate != "", returnDate != "" else {
            print("Error in passed departureDate/returnDate")
            return -1
        }
        //Default radius value for API
        let distanceFromAirport = "50"
        //Assign IATA codes for API
        var destinationAirport = ""
        if destinationLocation == "San Diego" {
            destinationAirport = "SAN"
        }
        else if destinationLocation == "Rome" {
            destinationAirport = "FCO"
        }
        else if destinationLocation == "New York" {
            destinationAirport = "JFK"
        }
        else {
            return -1
            print("Error finding IATA code")
        }
        let headers = [
            "Cache-Control": "no-cache",
            ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.sandbox.amadeus.com/v1.2/hotels/search-airport?apikey="+AMADEUSHOTELSAPIKEY+"&location="+destinationAirport+"&check_in="+departureDate+"&check_out="+returnDate+"&radius="+distanceFromAirport)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Error calling hotel API")
            } else {
                let httpResponse = response as? HTTPURLResponse
                self.hotelData = data
                self.hotelCallError = (error != nil) || (httpResponse?.statusCode != 200)
                self.hotelCallDone = true
            }
        })
        dataTask.resume()
        //Wait for API call to finish
        while !hotelCallDone { }
        //Check if any errors when calling API
        guard !hotelCallError else {
            print("Error calling hotel API")
            return -1
        }
        //Check if hotel data is there
        guard hotelData != nil else {
            print("Hotel data is nil")
            return -1
        }
        //Put data into JSON object
        let json = try? JSONSerialization.jsonObject(with: self.hotelData!, options: [])
        hotelCallDone = false
        
        //TODO: ALEXANDRA find the min cost using the JSON variable called json and pass it back to viewDidLoad
        //JSON object is being stored in json variable on line 184
        
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
