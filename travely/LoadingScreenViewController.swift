//
//  LoadingScreenViewController.swift
//  travely
//
//  Created by Spencer Mcdonald on 4/8/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    //User input values passsed from NewTripViewController
    var originLocation = ""
    var destinationLocation = ""
    var departureDate  = ""
    var returnDate = ""
    var numTravellers = ""
    var numDays = 0
    var reportRunDate = ""
    
    //Used for Amadeus Flights and hotels API method: getFlightMinCost, global variables used for getting data out of completion handler
    var flightcall_done = false
    var flightcall_errors = false
    var flight_data: Data?
    var hotelCallDone = false
    var hotelCallError = false
    var hotelData: Data?
    
    //Other Cost variables to be calculated
    var minFlightCost: Double?
    var minHotelCost: Double?
    var totalCost: Double?
    var foodCost: Double?
    var activitiesCost: Double?
    var publicTransportationCost: Double?
    var numberOfTravellers: Double?
    var totalTransportationCost: Double?
    
    //Structure to keep track of entire trip
    var newTrip: Trip?
    
    override func viewDidAppear(_ animated: Bool) {
        print("Call APIs")
        calculateTripData()
        
        //Create Trip data structure to store information
        newTrip = Trip(tripName: "Trip", tripTotalCost: totalCost!, tripAirfareCost: minFlightCost!, tripHotelCost: minHotelCost!, foodCost: foodCost!, activitiesCost: activitiesCost!, originLocation: originLocation, destinationLocation: destinationLocation, departureDate: departureDate, returnDate: returnDate, tripPublicTransportationCost: totalTransportationCost!, numberOfTravellers: numberOfTravellers!, reportRunDate: reportRunDate)
        
        //unwind to previous segue
        self.performSegue(withIdentifier: "unwindToRootViewController", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    /*
     * This function will call the Amadeus Flights Airfare API and retrieve lowest cost information for round trip
     *
     * @return - min cost of round trip from origin to destination, -1 on error
     */
    func getFlightMinCost() -> Double {
        //check originLocation and destinationLocation aren't empty
        guard originLocation != "", destinationLocation != "" else {
            print("Location values not set when trying to receive flight min cost")
            return -1
        }
        
        //Check returnDate isn't empty
        guard returnDate != "" else {
            print("Return date value not set when trying to receive flight min cost")
            return -1
        }
        
        //Find Correct IATA Codes for origin and destination
        guard let origin_IATA = findIATACode(location: originLocation) else {
            return -1
        }
        
        guard let destination_IATA = findIATACode(location: destinationLocation) else {
            return -1
        }
        
        //Set headers for both first and second leg of flight, Postman-Token is a placeholder that is used to bypass Chrome bug
        let headers = [
            "Cache-Control": "no-cache",
            "Postman-Token": "6127903e-057b-463d-b201-3a9ed5c61041"
        ]
        
        //Create API Request for first leg of flight
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=" + AMADEUSFLIGHTAPIKEY + "&origin=" + origin_IATA + "&destination=" + destination_IATA + "&departure_date=" + departureDate)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        callFlightAPIForLowCostData(request: request) //Call Flight API
        
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
        
        let tojson = try? JSONSerialization.jsonObject(with: self.flight_data!, options: []) as! [String: AnyObject]
        let toCost = calculateMinCostFromAmadeusFlightsResponse(amadeusResponse: tojson)
        
        flightcall_done = false //Set value back to false for next calculation
        
        //Create API Request for return leg of flight
        let second_request = NSMutableURLRequest(url: NSURL(string: "https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=" + AMADEUSFLIGHTAPIKEY + "&origin=" + destination_IATA + "&destination=" + origin_IATA + "&departure_date=" + returnDate)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        second_request.httpMethod = "GET"
        second_request.allHTTPHeaderFields = headers
        
        callFlightAPIForLowCostData(request: second_request) //Call flight API
        
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
        
        let retjson = try? JSONSerialization.jsonObject(with: self.flight_data!, options: []) as! [String: AnyObject]
        let retCost = calculateMinCostFromAmadeusFlightsResponse(amadeusResponse: retjson)
        
        flightcall_done = false //Set value back to false for next calculation
        
        return toCost + retCost
    }
    
    /**
     * This function actually calls Amadeus API to get the lowest cost for airfare
     * @request - Request to be made to Amadeus
     * @global self.flightcall_errors - set to determine if there was an error being called
     * @global self.flight_data - flight data returned from response
     * @global self.flightcall_done - used to determine if call to api is done so can move on
     */
    func callFlightAPIForLowCostData(request: NSMutableURLRequest){
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Error calling flight api")
            } else {
                let httpResponse = response as? HTTPURLResponse
                
                //Set global variables so they can be accessed outside of the completion handler
                self.flightcall_errors = (error != nil) || (httpResponse?.statusCode != 200)
                self.flight_data = data
                self.flightcall_done = true
            }
        })
        dataTask.resume()
        
        while !flightcall_done { } //Wait for api call to finish
        return
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
        guard let destinationAirport = findIATACode(location: destinationLocation) else {
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
        
        callHotelAPIForLowCostData(request: request) //Call API
        
        //Check if any errors when calling API
        guard !hotelCallError else {
            print("Error calling hotel API")
            hotelCallError = false
            return -1
        }
        
        //Check if hotel data is there
        guard hotelData != nil else {
            print("Hotel data is nil")
            return -1
        }
        
        //Put data into JSON object
        let json = try? JSONSerialization.jsonObject(with: self.hotelData!, options: []) as! [String: AnyObject]
        
        //find the min cost using the JSON variable called json and pass it back to viewDidLoad
        let minCost = calculateMinCostFromAmadeusHotelResponse(amadeusResponse: json)
        hotelCallDone = false //Set back to false so that next call can be made to api
        return minCost
    }
    
    /**
     * This function actually calls Amadeus API to get the lowest cost for hotels
     * @request - Request to be made to Amadeus
     * @global self.hotelData - set to determine if there was an error being called
     * @global self.hotelCallError - hotel data returned from response
     * @global self.hotelCallDone - used to determine if call to api is done so can move on
     */
    func callHotelAPIForLowCostData(request: NSMutableURLRequest){
        
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
        return
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
}
