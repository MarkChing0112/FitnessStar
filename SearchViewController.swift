//
//  SearchViewController.swift
//  FypTest_APP

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
    var filteredData = [Mode]()
    var gymRoom = [Mode]()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        getData()
        filteredData = gymRoom
        
    }
    
    func getData() {
        let db = Firestore.firestore()
        
        db.collection("GymRoomList").document("gymRoom").collection("TAIPO").getDocuments(){
            (snapshot, err) in
            
            for i in snapshot!.documents {
                let name = i.get("GymRoom_name") as? String ?? ""
                let address = i.get("Address") as? String ?? ""
                
                self.gymRoom.append(Mode(GymRoom_name: name, address: address))
                self.filteredData.append(Mode(GymRoom_name: name, address: address))
            }
            self.tableView.reloadData()
        }
    }


   func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row].GymRoom_name
        return cell
    }
    
    // tableView Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        if searchText == "" {
            filteredData = gymRoom
        }
        
        for word in gymRoom {
            if word.GymRoom_name.uppercased().contains(searchText.uppercased()) {
                
                filteredData.append(word)
            }
        }
        self.tableView.reloadData()
    }
}

