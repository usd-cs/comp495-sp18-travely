//
//  ActivitiesViewController.swift
//  travely
//
//  Created by Alexandra Leonidova on 3/11/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController {

    var originLocation = ""
    var destinaionLocation = ""
    var numOfTravellers = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var costData = callAPI(originPlace: originLocation, destinationPlace: destinaionLocation)
        print("Recieved from Segue. Origin Location: \(originLocation), Dectination Location: \(destinaionLocation), Num Travellers: \(numOfTravellers)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    //this function calls multiple API's, analyses their returns and outputs an array of expence destribution
    func callAPI(originPlace: String, destinationPlace: String) -> [String : Double]{
        print("Ready to pass data to API. originPlace \(originPlace), destinationPlace \(destinationPlace)")
        return ["place" : 1.1]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
