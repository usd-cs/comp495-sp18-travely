//
//  Activity.swift
//  travely
//
//  Created by Alexandra Leonidova on 4/26/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Activity: NSObject, NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(price, forKey: PropertyKey.price)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode name (Activity class)", log: OSLog.default, type: .debug)
            return nil
        }
        
        let price = aDecoder.decodeDouble(forKey: PropertyKey.price) as Double
        
        self.init(name: name, price: price)
    }
    
    var name: String
    var price: Double
    //var description: String?
    //var imageName: String?
    
    struct PropertyKey{
        static let name = "name"
        static let price = "price"
        // static let description = "description"
        // static let imageName = "imageName"
    }
    
    init?(name: String, price: Double){
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.price = price
        /*
        if description != nil{
            self.description = description
        } else {
            self.description = nil
        }
        if imageName != nil{
            self.imageName = imageName
        } else {
            self.imageName = nil
        }
         */
    }

}
