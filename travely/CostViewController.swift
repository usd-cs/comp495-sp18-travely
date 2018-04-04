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
    var numDays = 0
    

    //Used for Amadeus Flights API method: getFlightMinCost
    var flightcall_done = false
    var flightcall_errors = false
    var flight_data: Data?

    var hotelCallDone = false
    var hotelCallError = false
    var hotelData: Data?
    
    var calculateButtonWasPressed = false

    
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var airfareCostLabel: UILabel!
    @IBOutlet weak var hotelCostLabel: UILabel!
    @IBOutlet weak var publicTranportationLabel: UILabel!
    @IBOutlet weak var activitiesCostLabel: UILabel!
    @IBOutlet weak var foodCostLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        var minFlightCost = 0.0
        var minHotelCost = 0.0
        var totalCost = 0.0
        
        //Fill in the labels with dummy data
        var foodCost = 0.0
        var activitiesCost = 0.0
        var publicTransportationCost = 0.0
        var numberOfTravellers = (numTravellers as NSString).doubleValue
        if numberOfTravellers == 0 {
            numberOfTravellers = 1
        }
        if destinationLocation == "China" {
            foodCost = 14 * Double(numDays) * numberOfTravellers
            activitiesCost = 20 * Double(numDays) * numberOfTravellers
            publicTransportationCost = 17 * Double(numDays) * numberOfTravellers

        }
        else if destinationLocation == "San Diego" {
            foodCost = 40 * Double(numDays) * numberOfTravellers
            activitiesCost = 50 * Double(numDays) * numberOfTravellers
            publicTransportationCost = 18 * Double(numDays) * numberOfTravellers
        }
        else if destinationLocation == "Rome" {
            foodCost = 43 * Double(numDays) * numberOfTravellers
            activitiesCost = 39 * Double(numDays) * numberOfTravellers
            publicTransportationCost = 20 * Double(numDays) * numberOfTravellers
        }
        
        if calculateButtonWasPressed == true {
            minHotelCost = getHotelMinCost()
            minFlightCost = getFlightMinCost()
            //Multiply the flight cost by the number of travellers
            minFlightCost = minFlightCost * numberOfTravellers
        }
        calculateButtonWasPressed = false
        
        let totalTransportationCost = minFlightCost + publicTransportationCost
        let expenses = ["Transportation", "Accomodations", "Food", "Miscellaneous"]
        let costOfExpense = [totalTransportationCost, minHotelCost, foodCost, activitiesCost]
        setChart(dataPoints: expenses, values: costOfExpense)
        totalCost = minFlightCost + minHotelCost
        totalCostLabel.text = String(totalCost)
        airfareCostLabel.text = String(minFlightCost)
        hotelCostLabel.text = String(minHotelCost)
        publicTranportationLabel.text = String(publicTransportationCost)
        activitiesCostLabel.text = String(activitiesCost)
        foodCostLabel.text = String(foodCost)
        /*
        let expenses = ["Transportation", "Accomodations", "Food", "Miscellaneous"]
        let costOfExpense = [999.99, 999.99, 999.99, 999.99]
        setChart(dataPoints: expenses, values: costOfExpense)
        */
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
        if originLocation == "China" {
            origin_IATA = "PEK"
        } else if originLocation == "San Diego" {
            origin_IATA = "SAN"
        } else if originLocation == "Rome" {
            origin_IATA = "FCO"
        } else {
            print("Error determining IATA Code for flights API")
            return -1
        }
        
        if destinationLocation == "China" {
            destination_IATA = "PEK"
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
                
                self.flightcall_errors = (error != nil) || (httpResponse?.statusCode != 200)
                self.flight_data = data
                self.flightcall_done = true
            }
        })
        dataTask.resume()
        
        while !flightcall_done { } //Wait for api call to finish
        
        //Check if there were any errors when calling the api
        guard !flightcall_errors else {
            print("Error Calling flights api")
            flightcall_errors = false
            return -1
        }
        
        //Check if flight data is there
        guard flight_data != nil else {
            print("Flight Data is Nil")
            return -1
        }
        
        let json = try? JSONSerialization.jsonObject(with: self.flight_data!, options: []) as! [String: AnyObject]
        var minCost = calculateMinCostFromAmadeusFlightsResponse(amadeusResponse: json)
        flightcall_done = false //Set value back to false for next calculation
        return minCost
    }
    
    /*
     * This function calculates cheapers airfare price from Amadeus API response
     * @param amadeusResponse - Amadeus API response as [String: AnyObject]
     * @return currMin - the smallest cost in airfare (-1 if error)
     */
    func calculateMinCostFromAmadeusFlightsResponse(amadeusResponse json: [String: AnyObject]?) -> Double{
        var currMin: Double = 999999
        
        // do nester retrieve-casting to get all the prices
        if let json = json{
            if let results = json["results"]{
                for result in results as! [AnyObject]{
                    if let currFare = result["fare"] as? [String: Any]{
                        if let currPriceObject = currFare["price_per_adult"] as? [String: Any]{
                            if let currPrice = currPriceObject["total_fare"] as? String{
                                if let currPriceInt = Double(currPrice){
                                    if currPriceInt < currMin{
                                        currMin = currPriceInt
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //check for problem
        if currMin == 999999{
            return  -1
        }
        return currMin
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
        else if destinationLocation == "China" {
            destinationAirport = "PEK"
        }
        else {
            print("Error finding IATA code")
            return -1
           
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
        let json = try? JSONSerialization.jsonObject(with: self.hotelData!, options: []) as! [String: AnyObject]
        hotelCallDone = false
        
        //find the min cost using the JSON variable called json and pass it back to viewDidLoad

        var minCost = calculateMinCostFromAmadeusHotelResponse(amadeusResponse: json)
        return minCost
    }
    
    /*
     * This function calculates cheapers hotel price from Amadeus API response
     * @param amadeusResponse - Amadeus API response as [String: AnyObject]
     * @return currMin - the smallest cost for hotel (-1 if error)
     */
    func calculateMinCostFromAmadeusHotelResponse(amadeusResponse json: [String: AnyObject]?) -> Double{
        var currMin: Double = 999999
        
        // do nester retrieve-casting to get all the prices
        if let json = json{
            if let results = json["results"]{
                for result in results as! [AnyObject]{
                    if let currPriceObject = result["total_price"] as? [String: Any]{
                        if let currPrice = currPriceObject["amount"] as? String{
                            if let currPriceInt = Double(currPrice){
                                if currPriceInt < currMin{
                                    currMin = currPriceInt
                                }
                            }
                        }
                     
                    }
                }
            }
        }
        
        //check for problem
        if currMin == 999999{
            return  -1
        }
        return currMin
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
