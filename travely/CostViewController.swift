//
//  CostViewController.swift
//  travely
//
//  Created by Alexandra Leonidova on 3/11/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit
import Charts

class CostViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let expenses = ["Transportation", "Accomodations", "Food", "Miscellaneous"]
        let costOfExpense = [999.99, 999.99, 999.99, 999.99]
        setChart(dataPoints: expenses, values: costOfExpense)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: declare a func that takes in the data and preps the pie chart
    func setChart(dataPoints: [String], values: [Double]){
        var pieDataEntry: [PieChartDataEntry] = []
        //for-loop below creates data entries for each of the values
        for i in 0...(dataPoints.count-1){
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            pieDataEntry.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(values: pieDataEntry, label: "Total Cost")
        pieChartDataSet.colors = ChartColorTemplates.colorful()
        pieChartDataSet.label = "Total Cost Breakdown"
        pieChartDataSet.entryLabelFont = NSUIFont(name: "Arial", size: CGFloat(integerLiteral: 10))
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        pieChartView.data = pieChartData
    }
    
    /*
     *   This function will return the average price for the hotels and air travel
     *   Parameters: An array of doubles, all of the prices received from the API
     *   Returns: the average cost of all of prices, if returns -1 that means the array was empty
     */
    func findDataAverage(dataCosts: [Double]) -> Double{
        if dataCosts.count == 0 {
            return -1
        }
        var averageCost = 0.0;
        var totalCost = 0.0;
        for i in 0...(dataCosts.count-1) {
            totalCost = totalCost + dataCosts[i]
        }
        averageCost = totalCost/Double(dataCosts.count)
        return averageCost
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
