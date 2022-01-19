//
//  SearchViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 15/1/2022.
//

import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController {
    @IBOutlet weak var gymRoom1: UILabel!
    @IBOutlet weak var gymRoom2: UILabel!
    @IBOutlet weak var gymRoom3: UILabel!
    @IBOutlet weak var gymRoom4: UILabel!
    
    @IBOutlet weak var searchBar: UITextField!
    
    
    let database = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func searchButton(_ sender: Any) {
        database.child("\(searchBar)").observeSingleEvent(of: .value, with:
                                                            {snapshot in guard
            let value = snapshot.value as? [String: Any] else {return}
            
            let gym1 = value["Gym1"] as! String
            let gym2 = value["Gym2"] as! String
            let gym3 = value["Gym3"] as! String
            let gym4 = value["Gym4"] as! String
            
            self.gymRoom1.text = "1: \(gym1)"
            self.gymRoom2.text = "2: \(gym2)"
            self.gymRoom3.text = "3: \(gym3)"
            self.gymRoom4.text = "4: \(gym4)"
            
        })
    }
    
    @IBAction func location(_ sender: Any) {
        database.child("\(searchBar)").observeSingleEvent(of: .value, with:
                                                            {snapshot in guard
            let value = snapshot.value as? [String: Any] else {return}
            let gym1 = value["Gym1"] as! String
            
        })
    }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
