//
//  Trip.swift
//  travely
//
//  Created by Spencer Mcdonald on 4/2/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

class Trip {
    var tripName: String
    var tripTotalCost: Double
    var tripAirfareCost: Double
    var tripHotelCost: Double
    var foodCost: Double
    var activitiesCost: Double
    var originLocation: String
    var destinationLocation: String
    var departureDate: String
    var returnDate: String
    
    init?(tripName: String, tripTotalCost: Double, tripAirfareCost: Double, tripHotelCost: Double, foodCost: Double, activitiesCost: Double, originLocation: String, destinationLocation: String, departureDate: String, returnDate: String){
        
        if tripName.isEmpty || originLocation.isEmpty || destinationLocation.isEmpty || departureDate.isEmpty || returnDate.isEmpty {
            return nil
        }
        
        self.tripName = tripName
        self.tripTotalCost = tripTotalCost
        self.tripAirfareCost = tripAirfareCost
        self.tripHotelCost = tripHotelCost
        self.foodCost = foodCost
        self.activitiesCost = activitiesCost
        self.originLocation = originLocation
        self.destinationLocation = destinationLocation
        self.departureDate = departureDate
        self.returnDate = returnDate
    }
}
