//
//  LoadingScreenViewController.swift
//  travely
//
//  Created by Spencer Mcdonald on 4/8/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        //Call APIs
        print("Call APIs")
        
        
        
        //unwind to previous segue
        self.performSegue(withIdentifier: "unwindToRootViewController", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
