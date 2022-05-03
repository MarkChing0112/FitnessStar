//
//  TrainingRecord3ViewController.swift
//  FypTest_APP


import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TrainingRecord3ViewController: UIViewController {
    @IBOutlet weak var TrainAmount: UILabel!
    @IBOutlet weak var TrainSetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetUserData()
    }
    
    func GetUserData(){
        let ref = Database.database().reference()
        ref.child("User_Train_Selection").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? NSDictionary
           // let body = value?["Bodypart"] as? String ?? ""
            let TrainAmount = value?["TrainAmount"] as? String ?? ""
            let TrainsetAmount = value?["TrainSetAmount"] as? String ?? ""
            //show user selected session
            self.TrainSetLabel.text =  String(TrainsetAmount)
            self.TrainAmount.text = String(TrainAmount)
        }) { error in
          print(error.localizedDescription)
        }
    }
}
