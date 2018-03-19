//
//  Country.swift
//  travely
//
//  Created by Saul Garza on 3/18/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import Foundation
class Country{
    //data
    
    var cityName: String
    var etiquette: [String]
    var courtesy: [String]
    var activities: Activities
    //var activities: [String : String]
    
    init(cityName: String, etiquette: [String], courtesy: [String]) {
        self.etiquette = etiquette
        self.courtesy = courtesy
        self.cityName = cityName
        self.activities = Activities(cityName : cityName)
    }
}
