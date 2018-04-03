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
    
    init?(tripName: String){
        if tripName.isEmpty {
            return nil
        }
        
        self.tripName = tripName
    }
}
