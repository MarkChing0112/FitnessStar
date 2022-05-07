//
//  SearchTableViewController.swift
//  FypTest_APP


import UIKit
import Firebase

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    let data = ["Apple", "Avacode","Bananas", "Orange", "Pears", "P"]
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredData = data

        searchBar
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = filteredData[indexPath.row]

        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        if searchText == "" {
            filteredData = data
        }
        
        for word in data {
            if word.uppercased().contains(searchText.uppercased()) {
                
                filteredData.append(word)
            }
        }
        self.tableView.reloadData()
    }
}


