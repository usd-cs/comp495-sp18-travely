//
//  Settings.swift
//  travely
//
//  Created by Alexandra Leonidova on 4/22/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

class Settings {
    var budgetSet: Bool
    var budgetAmount: Double?
    
    var hotelRaiting: Int?
    
    var amenitiesPrefferenceSelected: [String]
    var activitiesPrefferenceSelected: [String]
    
    init(budgetSet: Bool, budgetAmount: Double?, hotelRaiting: Int?, amenitiesPrefferenceSelected: [String], activitiesPrefferenceSelected: [String]){
        self.budgetSet = budgetSet
        self.budgetAmount = budgetAmount
        self.hotelRaiting = hotelRaiting
        self.amenitiesPrefferenceSelected = amenitiesPrefferenceSelected
        self.activitiesPrefferenceSelected = activitiesPrefferenceSelected
    }
}
