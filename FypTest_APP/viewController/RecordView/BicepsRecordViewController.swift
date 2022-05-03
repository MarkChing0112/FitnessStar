//
//  BicepsViewController.swift
//  FypTest_APP


import UIKit

class BicepsRecordViewController: UIViewController {
    
    var lastUpdated: String!
    var gymType: String!
    var gymAccuracy: String!
    var gymTrainSet: Int!
    var gymTrainAmount: Int!
    var gymTrainTime: String!
    
    @IBOutlet weak var recordName: UILabel!
    @IBOutlet weak var recordDate: UILabel!
    @IBOutlet weak var recordTime: UILabel!
    @IBOutlet weak var recordTrainSet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outPutData()
    }
    
    func outPutData() {
        recordDate.text = lastUpdated
        recordTime.text = gymTrainTime
        recordTrainSet.text = "Set: \(String(gymTrainSet))"
    }
}
