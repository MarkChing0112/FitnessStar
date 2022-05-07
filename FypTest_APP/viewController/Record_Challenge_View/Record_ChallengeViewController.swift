//
//  Record_ChallengeViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 4/5/2022.
//

import UIKit
import FirebaseStorage
class Record_ChallengeViewController: UIViewController {
    
    var lastUpdated: String!
    var gymType: String!
    var gymAccuracy: String!
    var gymTimeLimit: String!
    var gymTrainAmount: Int!
    var gymRecordURL: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        printdata()
    }
    @IBAction func HomeBTNonTap(_ sender: Any) {
        let firstPageNavigationController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.firstPageNavigationController) as? FirstPageNavigationController
        view.window?.rootViewController = firstPageNavigationController
        view.window?.makeKeyAndVisible()
    }
    
    @IBOutlet weak var GymTypeImageView: UIImageView!
    @IBOutlet weak var GymTypeLBL: UILabel!
    @IBOutlet weak var GymDurationLBL: UILabel!
    @IBOutlet weak var GymAccuracyLBL: UILabel!
    @IBOutlet weak var GymTrainAmount: UILabel!
    func printdata(){
        //get text
        GymTypeLBL.text = gymType
        GymDurationLBL.text = gymTimeLimit
        GymAccuracyLBL.text = gymAccuracy
        GymTrainAmount.text = String(gymTrainAmount)
        
        //get image
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(gymRecordURL)
        
        fileRef.getData(maxSize: 10*3024*4032) { Data, Error in
            if Error == nil && Data != nil {
                self.GymTypeImageView.image = UIImage(data: Data!)
            }
        }
    }
}
