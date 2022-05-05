//
//  RecordDetailTableViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 5/5/2022.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseFirestore

class RecordDetailTableViewController: UITableViewController {
    var lastUpdated: String!
    var gymType: String!
    var gymAccuracy: String!
    var gymTrainSet: Int!
    var gymTrainAmount: Int!
    var gymTrainTime: String!
    var gymRecordURL: String!
    var User_SetDetail_collection: String!
    
    var record2 = [RecordDetailModel]()
    //record
    @IBOutlet weak var recordName: UILabel!
    @IBOutlet weak var recordTime: UILabel!
    @IBOutlet weak var recordTrainingReps: UILabel!
    @IBOutlet weak var recordTrainSet: UILabel!
    @IBOutlet weak var recordAccuracy: UILabel!
    
    @IBOutlet weak var GymTypeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        outPutData()
        getRecord()
        self.tableView.reloadData()
    }
    //view output data
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
    
    //table view data
    func getRecord() {
        let db = Firestore.firestore()
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            
            if let user = user {
                db.collection("RecordofSet").document(user.uid).collection(User_SetDetail_collection).getDocuments() {
                    (snapshot, err) in
                    
                    if err == nil {
                        if let snapshot = snapshot {
                            self.record2 = snapshot.documents.map {
                                r in
                                
                                return RecordDetailModel(
                                    SetAccuracy: r["Accuracy"] as? String ?? "",
                                    SetTrainSet: r["User_Train_Set"] as? String ?? "",
                                    SetTotalTime: r["Total_Time"] as? String ?? "",
                                    SetTimeOfSet: r["TimeOfSet"] as? String ?? ""
                                    )
                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let RecordCell = tableView.dequeueReusableCell(withIdentifier: "RecordCell3", for: indexPath) as! RecordDetailTableViewCell

        
        //get user set detail data
        RecordCell.User_Train_Set.text = record2[indexPath.row].SetTrainSet
        RecordCell.User_Total_Time.text = record2[indexPath.row].SetTotalTime
        RecordCell.TimeOfSet.text = record2[indexPath.row].SetTimeOfSet
        RecordCell.AccuraryLBL.text = record2[indexPath.row].SetAccuracy

        return RecordCell
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return record2.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
