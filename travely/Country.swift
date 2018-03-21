//
//  Country.swift
//  travely
//
//  Created by Saul Garza on 3/18/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//
//The class allows us to make multiple Country Objects
import Foundation
class Country{
    var etiquette: [String]
    var courtesy: [String]
    init(etiquette: [String], courtesy: [String]) {
        self.etiquette = etiquette
        self.courtesy = courtesy
    }
}
