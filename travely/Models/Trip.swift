//
//  Trip.swift
//  travely
//
//  Created by Spencer Mcdonald on 4/2/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit
import os.log


class Trip : NSObject,NSCoding{
    
    struct PropertyKey{
        static let tripName = "tripName"
        static let tripTotalCost = "tripTotalCost"
        static let tripAirfareCost = "tripAirfareCost"
        static let tripHotelCost = "tripHotelCost"
        static let foodCost = "foodCost"
        static let activitiesCost = "activitiesCost"
        static let originLocation = "originLocation"
        static let destinationLocation = "destinationLocation"
        static let departureDate = "departureDate"
        static let returnDate = "returnDate"
        static let tripPublicTransportationCost = "tripPublicTransportationCost"
        static let numberOfTravellers = "numberOfTravellers"
        static let reportRunDate = "reportRunDate"
        static let activityList = "activityList"
        static let settingsObject = "settingsObject"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("trips")
    
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
    var tripPublicTransportationCost: Double
    var numberOfTravellers: Double
    var reportRunDate: String
    var activityList: [Activity]
    var settingsObject: Settings
    
    init?(tripName: String, tripTotalCost: Double, tripAirfareCost: Double, tripHotelCost: Double, foodCost: Double, activitiesCost: Double, originLocation: String, destinationLocation: String, departureDate: String, returnDate: String, tripPublicTransportationCost: Double, numberOfTravellers: Double, reportRunDate: String, activityList: [Activity], settingsObject: Settings){
        
        if tripName.isEmpty || originLocation.isEmpty || destinationLocation.isEmpty || departureDate.isEmpty || returnDate.isEmpty || reportRunDate.isEmpty {
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
        self.tripPublicTransportationCost = tripPublicTransportationCost
        self.numberOfTravellers = numberOfTravellers
        self.reportRunDate = reportRunDate
        self.activityList = activityList
        self.settingsObject = settingsObject
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(tripName, forKey: PropertyKey.tripName)
        aCoder.encode(tripTotalCost, forKey: PropertyKey.tripTotalCost)
        aCoder.encode(tripAirfareCost, forKey: PropertyKey.tripAirfareCost)
        aCoder.encode(tripHotelCost, forKey: PropertyKey.tripHotelCost)
        aCoder.encode(foodCost, forKey: PropertyKey.foodCost)
        aCoder.encode(activitiesCost, forKey: PropertyKey.activitiesCost)
        aCoder.encode(originLocation, forKey: PropertyKey.originLocation)
        aCoder.encode(destinationLocation, forKey: PropertyKey.destinationLocation)
        aCoder.encode(departureDate, forKey: PropertyKey.departureDate)
        aCoder.encode(returnDate, forKey: PropertyKey.returnDate)
        aCoder.encode(tripPublicTransportationCost, forKey: PropertyKey.tripPublicTransportationCost)
        aCoder.encode(numberOfTravellers, forKey: PropertyKey.numberOfTravellers)
        aCoder.encode(reportRunDate, forKey: PropertyKey.reportRunDate)
        aCoder.encode(activityList, forKey: PropertyKey.activityList)
        aCoder.encode(settingsObject, forKey: PropertyKey.settingsObject)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let tripName = aDecoder.decodeObject(forKey: PropertyKey.tripName) as? String else {
            os_log("Unable to decode tripName", log: OSLog.default, type: .debug)
            return nil
        }
        guard let destinationLocation = aDecoder.decodeObject(forKey: PropertyKey.destinationLocation) as? String else {
            os_log("Unable to decode destinationLocation", log: OSLog.default, type: .debug)
            return nil
        }
        guard let originLocation = aDecoder.decodeObject(forKey: PropertyKey.originLocation) as? String else {
            os_log("Unable to decode originLocation", log: OSLog.default, type: .debug)
            return nil
        }
        guard let departureDate = aDecoder.decodeObject(forKey: PropertyKey.departureDate) as? String else {
            os_log("Unable to decode departureDate", log: OSLog.default, type: .debug)
            return nil
        }
        guard let returnDate = aDecoder.decodeObject(forKey: PropertyKey.returnDate) as? String else {
            os_log("Unable to decode returnDate", log: OSLog.default, type: .debug)
            return nil
        }
        guard let reportRunDate = aDecoder.decodeObject(forKey: PropertyKey.reportRunDate) as? String else {
            os_log("Unable to decode reportRunDate", log: OSLog.default, type: .debug)
            return nil
        }
        guard let activityList = aDecoder.decodeObject(forKey: PropertyKey.activityList) as? [Activity] else {
            os_log("Unable to decode activityList", log: OSLog.default, type: .debug)
            return nil
        }
        guard let settingsObject = aDecoder.decodeObject(forKey: PropertyKey.settingsObject) as? Settings else {
            os_log("Unable to decode settingsObject", log: OSLog.default, type: .debug)
            return nil
        }
        
        let tripPublicTransportationCost = aDecoder.decodeDouble(forKey: PropertyKey.tripPublicTransportationCost) as Double
        let numberOfTravellers = aDecoder.decodeDouble(forKey: PropertyKey.numberOfTravellers) as Double
        let tripTotalCost = aDecoder.decodeDouble(forKey: PropertyKey.tripTotalCost) as Double
        let tripAirfareCost = aDecoder.decodeDouble(forKey: PropertyKey.tripAirfareCost) as Double
        let tripHotelCost = aDecoder.decodeDouble(forKey: PropertyKey.tripHotelCost) as Double
        let foodCost = aDecoder.decodeDouble(forKey: PropertyKey.foodCost) as Double
        let activitiesCost = aDecoder.decodeDouble(forKey: PropertyKey.activitiesCost) as Double
        
        self.init(tripName: tripName, tripTotalCost: tripTotalCost, tripAirfareCost: tripAirfareCost, tripHotelCost: tripHotelCost, foodCost: foodCost, activitiesCost: activitiesCost, originLocation: originLocation, destinationLocation: destinationLocation, departureDate: departureDate, returnDate: returnDate, tripPublicTransportationCost: tripPublicTransportationCost, numberOfTravellers: numberOfTravellers, reportRunDate: reportRunDate, activityList: activityList, settingsObject: settingsObject)
    }
}

