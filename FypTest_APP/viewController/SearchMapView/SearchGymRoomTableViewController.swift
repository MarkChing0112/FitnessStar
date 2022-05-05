//
//  SearchGymRoomTableViewController.swift
//  FypTest_APP


import UIKit
import Firebase
import FirebaseFirestore

class SearchGymRoomTableViewController: UITableViewController {

    @IBOutlet weak var searchTextFied: UITextField!
    
    var activity = [SearchGymRoomModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        getGymRoom(searchTextFied.text!)
    }
    
    // get value from firebase
    func getGymRoom(_ searchValue: String) {
        let db = Firestore.firestore()
        
        db.collection("GymRoomList").document("gymRoom").collection("\(searchValue.uppercased())").getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.activity = snapshot.documents.map {
                        d in
                        return SearchGymRoomModel(x: d["x"] as? String ?? "",
                                                  y: d["y"] as? String ?? "",
                                                  GymRoom_name: d["GymRoom_name"] as? String ?? "",
                                                  TelPhone: d["TelPhone"] as? String ?? "",
                                                  Address: d["Address"] as? String ?? "",
                                                  Website: d["Website"] as? String ?? "",
                                                  GymRoomURL: d["GymRoomURL"] as? String ?? "")
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

    //cell view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gymRoomCell", for: indexPath) as! searchGymRoomTableViewCell
        
        cell.gymRoom.text = activity[indexPath.row].GymRoom_name
        
        return cell
    }
    
    // pass data to next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchMapViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                destination.x = activity[indexPath.row].x
                destination.y = activity[indexPath.row].y
                destination.GymRoom_name = activity[indexPath.row].GymRoom_name
                destination.TelPhone = activity[indexPath.row].TelPhone
                destination.Address = activity[indexPath.row].Address
                destination.Website = activity[indexPath.row].Website
                destination.GymRoomURL = activity[indexPath.row].GymRoomURL
                
            }
        }
    }
    
    // tableView Height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
