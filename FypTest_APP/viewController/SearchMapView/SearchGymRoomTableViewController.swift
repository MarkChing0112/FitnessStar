//
//  SearchGymRoomTableViewController.swift
//  FypTest_APP
//
//  Created by Isaac Lee on 25/3/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class SearchGymRoomTableViewController: UITableViewController {

    var activity = [Activity]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getGymRoom()
        self.tableView.reloadData()
    }
    
    func getGymRoom() {
        let db = Firestore.firestore()
        
        db.collection("\(searchBar)").getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.activity = snapshot.documents.map {
                        d in
                        return Activity(x: d["x"] as? String ?? "",
                                        y: d["y"] as? String ?? "",
                                        gymroom: d["name"] as? String ?? "")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
        return activity.count
    }

    //cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! searchGymRoomTableViewCell
        
        cell.gymRoom.text = activity[indexPath.row].gymroom

        // Configure the cell...

        return cell
    }
    
    // pass data to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchMapViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.x = activity[indexPath.row].x
                destination.y = activity[indexPath.row].y
                destination.gymroom = activity[indexPath.row].gymroom
                
            }
        }
    }
    
    // tableView Height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
