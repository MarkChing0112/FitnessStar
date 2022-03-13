//
//  SearchViewController.swift
//  FypTest_APP
//
//  Created by MARK ching on 15/1/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchMap : SearchMapViewController = SearchMapViewController()
    
    @IBOutlet weak var gymRoom1: UILabel!
    @IBOutlet weak var gymRoom2: UILabel!
    @IBOutlet weak var gymRoom3: UILabel!
    @IBOutlet weak var gymRoom4: UILabel!
    
    @IBOutlet weak var searchBar: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
    }
    
    @IBAction func gym1Location(_ sender: Any) {
        searchMap.x = 22.447640
        searchMap.y = 114.169125
    }
    
    @IBAction func gym2Location(_ sender: Any) {
        
    }
    
    @IBAction func gym3Location(_ sender: Any) {
    }
    
    @IBAction func gym4Location(_ sender: Any) {
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

