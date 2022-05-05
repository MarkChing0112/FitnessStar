//
//  RecordChallenageTableViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 4/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
class RecordChallenageTableViewController: UITableViewController {

    var recordChallenge = [RecordChallengeModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecord()
        self.tableView.reloadData()
    }
    
    @IBAction func HomeBTNOnTap(_ sender: Any) {
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

    func getRecord() {
        let db = Firestore.firestore()
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            
            if let user = user {
                db.collection("Record_Challenge").document(user.uid).collection("data").getDocuments() {
                    (snapshot, err) in
                    
                    if err == nil {
                        if let snapshot = snapshot {
                            self.recordChallenge = snapshot.documents.map {
                                r in
                                
                                return RecordChallengeModel(
                                    lastUpdated: r["lastUpdated"] as? String ?? "",
                                    gymType: r["GymType"] as? String ?? "",
                                    gymAccuracy: r["Accuracy"] as? String ?? "",
                                    gymTimeLimit: r["User_TimeLimit"] as? String ?? "",
                                    gymTrainAmount: r["User_Train_Amount"] as? Int ?? 0,
                                    gymRecordURL: r["Record_URL"] as? String ?? ""
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
        return recordChallenge.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let RecordCell = tableView.dequeueReusableCell(withIdentifier: "RC1Cell", for: indexPath) as! RecordChallengeTableViewCell
        //get firebase storage image
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(recordChallenge[indexPath.row].gymRecordURL)
        
        fileRef.getData(maxSize: 10*3024*4032) { Data, Error in
            if Error == nil && Data != nil {
                RecordCell.gymTypeImageView.image = UIImage(data: Data!)
            }
        }
        RecordCell.gymTypeLabel.text = recordChallenge[indexPath.row].gymType
        RecordCell.gymTimeLabel.text = recordChallenge[indexPath.row].lastUpdated

        return RecordCell
    }
    
    // pass data to next page
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? Record_ChallengeViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                destination.lastUpdated = recordChallenge[indexPath.row].lastUpdated
                destination.gymType = recordChallenge[indexPath.row].gymType
                destination.gymAccuracy = recordChallenge[indexPath.row].gymAccuracy
                destination.gymTimeLimit = recordChallenge[indexPath.row].gymTimeLimit
                destination.gymTrainAmount = recordChallenge[indexPath.row].gymTrainAmount
                destination.gymRecordURL = recordChallenge[indexPath.row].gymRecordURL
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

}

