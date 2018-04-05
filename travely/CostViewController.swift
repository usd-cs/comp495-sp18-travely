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
    var setLabelsToZero = true
    var recalculateTrip = false
    
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
    
    //This function is called everytime the cost tab is visible
    override func viewWillAppear(_ animated: Bool) {
        if calculateButtonWasPressed == true {
            setLabelsToZero = false
            //Calculate the information, this is called everytime the calculate button is pressed but not everytime the cost tab is navigated to
            if recalculateTrip == true {
                calculateTripData()
            }
            //Set labels
            setLabelsWithData()
        }
            //This will set the prices to $0 if no trip has been calculated and the user navigates to cost tab
        else if setLabelsToZero == true {
            zeroPrices()
        }
    }
    
    //This function calculates the data for a trip with dummy data and API data
    func calculateTripData() {
        initializeVaribles()
        
        if destinationLocation == "China" {
            foodCost = 14 * Double(numDays) * numberOfTravellers!
            activitiesCost = 20 * Double(numDays) * numberOfTravellers!
            publicTransportationCost = 17 * Double(numDays) * numberOfTravellers!
            
        }
        else if destinationLocation == "San Diego" {
            foodCost = 40 * Double(numDays) * numberOfTravellers!
            activitiesCost = 50 * Double(numDays) * numberOfTravellers!
            publicTransportationCost = 18 * Double(numDays) * numberOfTravellers!
        }
        else if destinationLocation == "Rome" {
            foodCost = 43 * Double(numDays) * numberOfTravellers!
            activitiesCost = 39 * Double(numDays) * numberOfTravellers!
            publicTransportationCost = 20 * Double(numDays) * numberOfTravellers!
        }
        
        minHotelCost = getHotelMinCost()
        minFlightCost = getFlightMinCost()
        //Multiply the flight cost by the number of travellers
        minFlightCost = minFlightCost! * numberOfTravellers!
        totalTransportationCost = minFlightCost! + publicTransportationCost!
        totalCost = minFlightCost! + minHotelCost!
        recalculateTrip = false
    }
    
    //This function uses the existing or newly calculated information to populate the labels and chart
    func setLabelsWithData() {
        let expenses = ["Transportation", "Accomodations", "Food", "Miscellaneous"]
        let costOfExpense = [totalTransportationCost, minHotelCost, foodCost, activitiesCost]
        setChart(dataPoints: expenses, values: costOfExpense as! [Double])
        totalCostLabel.text = String(describing: totalCost!)
        airfareCostLabel.text = String(describing: minFlightCost!)
        hotelCostLabel.text = String(describing: minHotelCost!)
        publicTranportationLabel.text = String(describing: publicTransportationCost!)
        activitiesCostLabel.text = String(describing: activitiesCost!)
        foodCostLabel.text = String(describing: foodCost!)
    }
    
    //This function resets all of the variables everytime a new trip is calculated
    func initializeVaribles() {
        minFlightCost = 0.0
        minHotelCost = 0.0
        totalCost = 0.0
        foodCost = 0.0
        activitiesCost = 0.0
        publicTransportationCost = 0.0
        numberOfTravellers = (numTravellers as NSString).doubleValue
        if numberOfTravellers == 0 {
            numberOfTravellers = 1
        }
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
        
        //Find Correct IATA Codes for origin and destination
        guard var origin_IATA = findIATACode(location: originLocation) else {
            return -1
        }
        
        guard var destination_IATA = findIATACode(location: destinationLocation) else {
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
    
    /**
     * This function takes in a location and finds the IATA code
     *
     * @param location - location to find IATA Code for
     * @return - IATA Code or nil if not found
     */
    func findIATACode(location: String) -> String? {
        if location == "China" {
            return "PEK"
        } else if location == "San Diego" {
            return "SAN"
        } else if location == "Rome" {
            return "FCO"
        } else {
            print("Error determining IATA Code for flights API")
            return nil
        }
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
        guard var destinationAirport = findIATACode(location: destinationLocation) else {
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

