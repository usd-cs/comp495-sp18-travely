//
//  AboutViewController.swift
//  travely
//
//  Created by Alexandra Leonidova on 3/11/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var countryName = ""
    
    let FIXER_BASE_URL = "http://data.fixer.io/api/"
    
    let rates = ["USD", "EUR", "MXN","GBP"]
    
    @IBOutlet weak var exchangeResult: UILabel!
    @IBOutlet weak var exchangeAmt: UITextField!
    @IBOutlet weak var currCurrency: UIPickerView!
    @IBOutlet weak var destinationCurrency: UIPickerView!
    @IBOutlet weak var etiquetteLabel: UILabel!
    @IBOutlet weak var etiquetteText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if countryName != "" {
            populateEtiquette()
        }
        else {
            etiquetteLabel.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rates[row]
    }
    
    //when the button is pressed, this will check for errors, then make the api call
    @IBAction func calcExchangeRate(_ sender: UIButton) {
        if let amount = Int(exchangeAmt.text!){
            print(amount)
        }
        else{
            print("Invalid Amount. Please try again.")
        }
    }
    
    func populateEtiquette() {
        etiquetteLabel.text = countryName
        if let path = Bundle.main.path(forResource: "countryEtiquette", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: "----")
                //Go through the entries in countryEtiquette.txt and set the text to the appropriate country's etiquette
                for i in (0...myStrings.count-1) {
                    if myStrings[i].contains(countryName + " Etiquette") {
                        etiquetteText.text = myStrings[i]
                        break
                    }
                }
                etiquetteText.sizeToFit() 
                }
            catch {
                print(error)
            }
        }
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
