//
//  SearchViewController.swift
//  FypTest_APP

import UIKit
import Firebase
import FirebaseStorage
class SearchGymViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
    var filteredData = [SearchGymRoomModel]()
    var gymRoom = [SearchGymRoomModel]()

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
        
        db.collection("GymRoomList").document("gymRoom").collection("ALL").getDocuments(){
            (snapshot, err) in
            
            for i in snapshot!.documents {
                let name = i.get("GymRoom_name") as? String ?? ""
                let address = i.get("Address") as? String ?? ""
                let District = i.get("District") as? String ?? ""
                let x = i.get("x") as? String ?? ""
                let y = i.get("y") as? String ?? ""
                let TelPhone = i.get("TelPhone") as? String ?? ""
                let Website = i.get("Website") as? String ?? ""
                let GymRoomURL = i.get("GymRoomURL") as? String ?? ""
                self.gymRoom.append(SearchGymRoomModel(
                    x: x,
                    y: y,
                    GymRoom_name: name,
                    TelPhone: TelPhone,
                    Address: address,
                    Website: Website,
                    District: District,
                    GymRoomURL: GymRoomURL))
                self.filteredData.append(SearchGymRoomModel(
                    x: x,
                    y: y,
                    GymRoom_name: name,
                    TelPhone: TelPhone,
                    Address: address,
                    Website: Website,
                    District: District,
                    GymRoomURL: GymRoomURL))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! searchGymRoomTableViewCell
        
        cell.gymRoom.text = "\(filteredData[indexPath.row].GymRoom_name!) \(filteredData[indexPath.row].District!)"
        
        //get firebase storage image
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(filteredData[indexPath.row].GymRoomURL)
        
        fileRef.getData(maxSize: 10*3024*4032) { Data, Error in
            if Error == nil && Data != nil {
                cell.GymRoomImageView.image = UIImage(data: Data!)
            }
        }
        
        return cell
    }
    
    // tableView Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchMapViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                destination.x = filteredData[indexPath.row].x
                destination.y = filteredData[indexPath.row].y
                destination.GymRoom_name = filteredData[indexPath.row].GymRoom_name
                destination.TelPhone = filteredData[indexPath.row].TelPhone
                destination.Address = filteredData[indexPath.row].Address
                destination.Website = filteredData[indexPath.row].Website
                destination.GymRoomURL = filteredData[indexPath.row].GymRoomURL
                
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        if searchText == "" {
            filteredData = gymRoom
        }
        
        for word in gymRoom {
            if (word.GymRoom_name.uppercased().contains(searchText.uppercased()) || word.District.uppercased().contains(searchText.uppercased())){
                
                filteredData.append(word)
            }
        }
        self.tableView.reloadData()
    }
}

