//
//  RecordTableViewController.swift
//  FypTest_APP

import UIKit
import Firebase
import FirebaseFirestore

class RecordTableViewController: UITableViewController {

    var record = [RecordModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecord()
        self.tableView.reloadData()
    }
    
    func getRecord() {
        let db = Firestore.firestore()
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            
            if let user = user {
                db.collection("Reocrd").document(user.uid).collection("data").getDocuments() {
                    (snapshot, err) in
                    
                    if err == nil {
                        if let snapshot = snapshot {
                            self.record = snapshot.documents.map {
                                r in
                                
                                return RecordModel(
                                    lastUpdated: r["lastUpdated"] as? String ?? "",
                                    gymType: r["GymType"] as? String ?? "",
                                    gymAccuracy: r["Accuracy"] as? String ?? "",
                                    gymTrainSet: r["User_Train_Set"] as? String ?? "",
                                    gymTrainAmount: r["User_Train_Amount"] as? Int ?? 0,
                                    gymTrainTime: r["User_Time"] as? String ?? ""
                                    )
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordTableViewCell

        cell.gymTypeLabel.text = record[indexPath.row].gymType
        cell.gymTimeLabel.text = record[indexPath.row].lastUpdated

        return cell
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
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
