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

    }
    //view output data
    func outPutData() {
        //get user train data form server

        
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
                                    SetTrainSet: r["User_Train_Set"] as? Int ?? 0,
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
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
