//
//  TrainingSelectionViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 15/1/2022.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth

class TrainingSelectionViewController: UIViewController {
    //var
    var BICEPS = false;
    var TRICEPS = false;
    var CHEST = false;
    var BACK = false;
    //var of program amount
    var trainSet = 0;
    var trainamount = 0;
    //btn outlet use to set stroke
    @IBOutlet var BicepsOutBtn: UIButton!
    @IBOutlet var TricepsOutBtn: UIButton!
    @IBOutlet var ChestOutBtn: UIButton!
    @IBOutlet var BackOutBtn: UIButton!
    //label amount
    
    @IBOutlet var SetAmountLabel: UILabel!
    @IBOutlet var TrainAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func BicepsBtn(_ sender: Any) {
        BICEPS = true;
        TRICEPS = false;
        CHEST = false;
        BACK = false;
        CheckBSelect()
    }
    @IBAction func TricepsBtn(_ sender: Any) {
        BICEPS = false;
        TRICEPS = true;
        CHEST = false;
        BACK = false;
        CheckBSelect()
    }
    @IBAction func ChestBtn(_ sender: Any) {
        BICEPS = false;
        TRICEPS = false;
        CHEST = true;
        BACK = false;
        CheckBSelect()
    }
    @IBAction func BackBtn(_ sender: Any) {
        BICEPS = false;
        TRICEPS = false;
        CHEST = false;
        BACK = true;
        CheckBSelect()
    }
    
    func CheckBSelect(){
        if (BICEPS == true){
            self.BicepsOutBtn.backgroundColor = UIColor.green
            self.TricepsOutBtn.backgroundColor = UIColor.white
            self.ChestOutBtn.backgroundColor = UIColor.white
            self.BackOutBtn.backgroundColor = UIColor.white
        }else if(TRICEPS == true){
            self.TricepsOutBtn.backgroundColor = UIColor.green
            self.BicepsOutBtn.backgroundColor = UIColor.white
            self.ChestOutBtn.backgroundColor = UIColor.white
            self.BackOutBtn.backgroundColor = UIColor.white
        }else if(CHEST == true){
            self.ChestOutBtn.backgroundColor = UIColor.green
            self.TricepsOutBtn.backgroundColor = UIColor.white
            self.BicepsOutBtn.backgroundColor = UIColor.white
            self.BackOutBtn.backgroundColor = UIColor.white
        }else if(BACK == true){
            self.BackOutBtn.backgroundColor = UIColor.green
            self.ChestOutBtn.backgroundColor = UIColor.white
            self.TricepsOutBtn.backgroundColor = UIColor.white
            self.BicepsOutBtn.backgroundColor = UIColor.white
        }
    }
    //show Alert
    func showAlertM(){
        let alert = UIAlertController(title: "amount can't < 0!!!!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func minBtn(_ sender: Any) {
        if trainSet > 0{
            trainSet -= 1
        }else{
            showAlertM()
        }
    
    }
    @IBAction func trainsetplus(_ sender: Any) {
        if trainSet <= 5{
            trainSet +1
        }else{
            
        }

    }
    @IBAction func NextPageBtnOnTap(_ sender: Any) {
        
        
    }
}
