//
//  Settings.swift
//  travely
//
//  Created by Alexandra Leonidova on 4/22/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import Foundation

struct Settings: Codable{
    var budgetSet: Bool
    var budgetAmount: Double?
    
    var hotelRaiting: Int?
    
    var amenitiesPrefferenceSelected: [String]
    var activitiesPrefferenceSelected: [String]
}
