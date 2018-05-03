//
//  Settings.swift
//  travely
//
//  Created by Alexandra Leonidova on 4/22/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//
import UIKit
import os.log

class Settings : NSObject, NSCoding {
    var budgetSet: Bool
    var budgetAmount: Double
    
    var directFlightOnly: Bool
    
    var culturalActivitiesPrefference: Int
    var outdoorsActivitiesPrefference: Int
    var nightlifeActivitiesPrefference: Int

    var hotelRaiting: Int
    
    var amenitiesPrefferenceSelected: [String]
    var activitiesPrefferenceSelected: [String]
    
    struct PropertyKey{
        static let budgetSet = "budgetSet"
        static let budgetAmount = "budgetAmount"
        static let directFlightOnly = "directFlightOnly"
        static let culturalActivitiesPrefference = "culturalActivitiesPrefference"
        static let outdoorsActivitiesPrefference = "outdoorsActivitiesPrefference"
        static let nightlifeActivitiesPrefference = "nightlifeActivitiesPrefference"
        static let hotelRaiting = "hotelRaiting"
        static let amenitiesPrefferenceSelected = "amenitiesPrefferenceSelected"
        static let activitiesPrefferenceSelected = "activitiesPrefferenceSelected"
    }
    
    init(budgetSet: Bool, budgetAmount: Double, directFlightOnly: Bool, culturalActivitiesPrefference: Int, outdoorsActivitiesPrefference: Int, nightlifeActivitiesPrefference: Int, hotelRaiting: Int, amenitiesPrefferenceSelected: [String], activitiesPrefferenceSelected: [String]){
        self.budgetSet = budgetSet
        self.budgetAmount = budgetAmount
        self.directFlightOnly = directFlightOnly
        self.culturalActivitiesPrefference = culturalActivitiesPrefference
        self.outdoorsActivitiesPrefference = outdoorsActivitiesPrefference
        self.nightlifeActivitiesPrefference = nightlifeActivitiesPrefference
        self.hotelRaiting = hotelRaiting
        self.amenitiesPrefferenceSelected = amenitiesPrefferenceSelected
        self.activitiesPrefferenceSelected = activitiesPrefferenceSelected
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(budgetSet, forKey: PropertyKey.budgetSet)
        aCoder.encode(budgetAmount, forKey: PropertyKey.budgetAmount)
        aCoder.encode(directFlightOnly, forKey: PropertyKey.directFlightOnly)
        aCoder.encode(culturalActivitiesPrefference, forKey: PropertyKey.culturalActivitiesPrefference)
        aCoder.encode(outdoorsActivitiesPrefference, forKey: PropertyKey.outdoorsActivitiesPrefference)
        aCoder.encode(nightlifeActivitiesPrefference, forKey: PropertyKey.nightlifeActivitiesPrefference)
        aCoder.encode(hotelRaiting, forKey: PropertyKey.hotelRaiting)
        aCoder.encode(amenitiesPrefferenceSelected, forKey: PropertyKey.amenitiesPrefferenceSelected)
        aCoder.encode(activitiesPrefferenceSelected, forKey: PropertyKey.activitiesPrefferenceSelected)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let amenitiesPrefferenceSelected = aDecoder.decodeObject(forKey: PropertyKey.amenitiesPrefferenceSelected) as? [String] else {
            os_log("Unable to decode amenitiesPrefferenceSelected", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let activitiesPrefferenceSelected = aDecoder.decodeObject(forKey: PropertyKey.activitiesPrefferenceSelected) as? [String] else {
            os_log("Unable to decode activitiesPrefferenceSelected", log: OSLog.default, type: .debug)
            return nil
        }
        
        let budgetAmount = aDecoder.decodeDouble(forKey: PropertyKey.budgetAmount) as Double
        let hotelRaiting = aDecoder.decodeInteger(forKey: PropertyKey.hotelRaiting) as Int
        let budgetSet = aDecoder.decodeBool(forKey: PropertyKey.budgetSet) as Bool
        let directFlightOnly = aDecoder.decodeBool(forKey: PropertyKey.directFlightOnly) as Bool
        
        let culturalActivitiesPrefference = aDecoder.decodeInteger(forKey: PropertyKey.culturalActivitiesPrefference) as Int
        let outdoorsActivitiesPrefference = aDecoder.decodeInteger(forKey: PropertyKey.outdoorsActivitiesPrefference) as Int
        let nightlifeActivitiesPrefference = aDecoder.decodeInteger(forKey: PropertyKey.nightlifeActivitiesPrefference) as Int
        
        self.init(budgetSet: budgetSet, budgetAmount: budgetAmount, directFlightOnly: directFlightOnly, culturalActivitiesPrefference: culturalActivitiesPrefference, outdoorsActivitiesPrefference: outdoorsActivitiesPrefference, nightlifeActivitiesPrefference: nightlifeActivitiesPrefference, hotelRaiting: hotelRaiting, amenitiesPrefferenceSelected: amenitiesPrefferenceSelected, activitiesPrefferenceSelected: activitiesPrefferenceSelected)
    }
}
