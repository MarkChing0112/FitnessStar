//
//  BicepsViewController.swift
//  FypTest_APP


import UIKit
import FirebaseStorage
import Firebase
class BicepsRecordViewController: UIViewController {
    
    var lastUpdated: String!
    var gymType: String!
    var gymAccuracy: String!
    var gymTrainSet: Int!
    var gymTrainAmount: Int!
    var gymTrainTime: String!
    var gymRecordURL: String!
    var User_SetDetail_collection: String!
    
    @IBOutlet weak var recordName: UILabel!
    @IBOutlet weak var recordTime: UILabel!
    @IBOutlet weak var recordTrainingReps: UILabel!
    @IBOutlet weak var recordTrainSet: UILabel!
    @IBOutlet weak var recordAccuracy: UILabel!
    
    @IBOutlet weak var GymTypeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        outPutData()
    }
    
    func outPutData() {
        //get user train data form server
        recordAccuracy.text = gymAccuracy
        recordTrainingReps.text = String(gymTrainAmount)
        recordTime.text = gymTrainTime
        recordTrainSet.text = String(gymTrainSet)
        
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
