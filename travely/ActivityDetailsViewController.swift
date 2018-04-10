//
//  ActivityDetailsViewController.swift
//  travely
//
//  Created by Alexandra Leonidova on 4/9/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    var selectedActivity: [String: String]?
    
    @IBOutlet weak var activityCostLabel: UILabel!
    @IBOutlet weak var activityTitleLable: UILabel!
    @IBOutlet weak var activityDetailedDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedActivity = selectedActivity{
            activityTitleLable.text = selectedActivity["name"]
            if let price = Int(selectedActivity["price"]!){
                if price > 0{
                    activityCostLabel?.text = "$\(price)"
                } else {
                    activityCostLabel?.text = "FREE"
                }
            } else {
                activityCostLabel?.text = "???"
            }
            activityDetailedDescriptionTextView.text = selectedActivity["description"]
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
