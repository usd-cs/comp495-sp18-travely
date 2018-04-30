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
    var budgetAmount: Double?
    
    var hotelRaiting: Int?
    
    var amenitiesPrefferenceSelected: [String]
    var activitiesPrefferenceSelected: [String]
    
    struct PropertyKey{
        static let budgetSet = "budgetSet"
        static let budgetAmount = "budgetAmount"
        static let hotelRaiting = "hotelRaiting"
        static let amenitiesPrefferenceSelected = "amenitiesPrefferenceSelected"
        static let activitiesPrefferenceSelected = "activitiesPrefferenceSelected"
    }
    
    init(budgetSet: Bool, budgetAmount: Double?, hotelRaiting: Int?, amenitiesPrefferenceSelected: [String], activitiesPrefferenceSelected: [String]){
        self.budgetSet = budgetSet
        self.budgetAmount = budgetAmount
        self.hotelRaiting = hotelRaiting
        self.amenitiesPrefferenceSelected = amenitiesPrefferenceSelected
        self.activitiesPrefferenceSelected = activitiesPrefferenceSelected
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(budgetSet, forKey: PropertyKey.budgetSet)
        aCoder.encode(budgetAmount, forKey: PropertyKey.budgetAmount)
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
        
        
        self.init(budgetSet: budgetSet, budgetAmount: budgetAmount, hotelRaiting: hotelRaiting, amenitiesPrefferenceSelected: amenitiesPrefferenceSelected, activitiesPrefferenceSelected: activitiesPrefferenceSelected)
    }
}
