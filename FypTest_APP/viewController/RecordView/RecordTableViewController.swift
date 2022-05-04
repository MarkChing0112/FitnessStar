//
//  RecordTableViewController.swift
//  FypTest_APP

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class RecordTableViewController: UITableViewController {

    var record = [RecordModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecord()
        self.tableView.reloadData()
    }
    
    @IBAction func HomeBTNOnTap(_ sender: Any) {
        
        
        
    }
    func getRecord() {
        let db = Firestore.firestore()
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            
            if let user = user {
                db.collection("Record").document(user.uid).collection("data").getDocuments() {
                    (snapshot, err) in
                    
                    if err == nil {
                        if let snapshot = snapshot {
                            self.record = snapshot.documents.map {
                                r in
                                
                                return RecordModel(
                                    lastUpdated: r["lastUpdated"] as? String ?? "",
                                    gymType: r["GymType"] as? String ?? "",
                                    gymAccuracy: r["Accuracy"] as? String ?? "",
                                    gymTrainSet: r["User_Train_Set"] as? Int ?? 0,
                                    gymTrainAmount: r["User_Train_Amount"] as? Int ?? 0,
                                    gymTrainTime: r["User_Time"] as? String ?? ""
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return record.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let RecordCell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordTableViewCell

        RecordCell.gymTypeLabel.text = record[indexPath.row].gymType
        RecordCell.gymTimeLabel.text = record[indexPath.row].lastUpdated

        return RecordCell
    }
    
    // pass data to next page
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BicepsRecordViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                destination.lastUpdated = record[indexPath.row].lastUpdated
                destination.gymType = record[indexPath.row].gymType
                destination.gymAccuracy = record[indexPath.row].gymAccuracy
                destination.gymTrainSet = record[indexPath.row].gymTrainSet
                destination.gymTrainAmount = record[indexPath.row].gymTrainAmount
                destination.gymTrainTime = record[indexPath.row].gymTrainTime
                
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

}
