//
//  BicepsViewController.swift
//  FypTest_APP


import UIKit

class BicepsRecordViewController: UIViewController {
    
    var lastUpdated: String!
    var gymType: String!
    var gymAccuracy: String!
    var gymTrainSet: String!
    var gymTrainAmount: String!
    var gymTrainTime: String!
    
    @IBOutlet weak var recordName: UILabel!
    @IBOutlet weak var recordDate: UILabel!
    @IBOutlet weak var recordTime: UILabel!
    @IBOutlet weak var recordTrainSet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
