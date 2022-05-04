//
//  ChallengeViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 4/5/2022.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ChallengeViewController: UIViewController {

    //var
    var BICEPS = false;
    var TRICEPS = false;
    var CHEST = false;
    var BACK = false;
    //var of program amount
    var Time_Minus = 5;
    //btn outlet use to set stroke
    @IBOutlet var BicepsOutBtn: UIButton!
    @IBOutlet var TricepsOutBtn: UIButton!
    @IBOutlet var ChestOutBtn: UIButton!
    @IBOutlet var BackOutBtn: UIButton!
    //imageview
    @IBOutlet weak var Bicepsimage: UIButton!
    @IBOutlet weak var Tricepsimage: UIButton!
    @IBOutlet weak var ChestImage: UIButton!
    @IBOutlet weak var BackImage: UIButton!
    //label amount
    @IBOutlet var SetAmountLabel: UILabel!
    @IBOutlet var TimeLabel: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimeLabel.text = String(Time_Minus);
    }
    
//Btn func
    @IBAction func BicepsBtn(_ sender: Any) {
        if (BICEPS == true){
            BICEPS = false;
            self.BicepsOutBtn.backgroundColor = UIColor.white
        }else{
        BICEPS = true;
        TRICEPS = false;
        CHEST = false;
        BACK = false;
        CheckBSelect()
        }}
    @IBAction func TricepsBtn(_ sender: Any) {
        if (TRICEPS == true){
            TRICEPS = false;
            self.TricepsOutBtn.backgroundColor = UIColor.white
        }else{
        BICEPS = false;
        TRICEPS = true;
        CHEST = false;
        BACK = false;
        CheckBSelect()
        }}
    @IBAction func ChestBtn(_ sender: Any) {
        if (CHEST == true){
            CHEST = false;
            self.ChestOutBtn.backgroundColor = UIColor.white
        }else{
        BICEPS = false;
        TRICEPS = false;
        CHEST = true;
        BACK = false;
        CheckBSelect()
        }}
    @IBAction func BackBtn(_ sender: Any) {
        if (BACK == true){
            BACK = false;
            self.BackOutBtn.backgroundColor = UIColor.white
        }else{
        BICEPS = false;
        TRICEPS = false;
        CHEST = false;
        BACK = true;
        CheckBSelect()
    }}
    
    func CheckBSelect(){
        if (BICEPS == true){
            self.BicepsOutBtn.backgroundColor = UIColor(red: 95/255, green: 201/255, blue: 200/255, alpha: 0.5)
            self.TricepsOutBtn.backgroundColor = UIColor.white
            self.ChestOutBtn.backgroundColor = UIColor.white
            self.BackOutBtn.backgroundColor = UIColor.white
        }else if(TRICEPS == true){
            self.TricepsOutBtn.backgroundColor = UIColor(red: 95/255, green: 201/255, blue: 200/255, alpha: 0.5)
            self.BicepsOutBtn.backgroundColor = UIColor.white
            self.ChestOutBtn.backgroundColor = UIColor.white
            self.BackOutBtn.backgroundColor = UIColor.white
        }else if(CHEST == true){
            self.ChestOutBtn.backgroundColor = UIColor(red: 95/255, green: 201/255, blue: 200/255, alpha: 0.5)
            self.TricepsOutBtn.backgroundColor = UIColor.white
            self.BicepsOutBtn.backgroundColor = UIColor.white
            self.BackOutBtn.backgroundColor = UIColor.white
        }else if(BACK == true){
            self.BackOutBtn.backgroundColor = UIColor(red: 95/255, green: 201/255, blue: 200/255, alpha: 0.5)
            self.ChestOutBtn.backgroundColor = UIColor.white
            self.TricepsOutBtn.backgroundColor = UIColor.white
            self.BicepsOutBtn.backgroundColor = UIColor.white
        }
    }
    //show Alert
    func showAlertM(){
        let alert = UIAlertController(title: "amount can't < 1!!!!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    func showAlertError(){
        let alert = UIAlertController(title: "Error!!!!!", message: "Please select the body part", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    //Set btn
    //amount Btn
    @IBAction func amountminBtn(_ sender: Any) {
        if Time_Minus > 1{
            Time_Minus -= 1
            TimeLabel.text = String(Time_Minus)
        }else{
            showAlertM()
        }
    }
    
    @IBAction func amountPlusBtn(_ sender: Any) {
        if Time_Minus <= 29{
            Time_Minus += 1
            TimeLabel.text = String(Time_Minus)
        }
    }
    //to Selected body part page
    func toTrainBRecord(){
        let namestoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = namestoryboard.instantiateViewController(withIdentifier: "TR1") as! TrainingRecord1ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    func toTrainTRecord(){
        let namestoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = namestoryboard.instantiateViewController(withIdentifier: "TR2") as! TrainingRecord2ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    func toTrainCRecord(){
        let namestoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = namestoryboard.instantiateViewController(withIdentifier: "TR3") as! TrainingRecord3ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    func toTrainBARecord(){
        let namestoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = namestoryboard.instantiateViewController(withIdentifier: "TR4") as! TrainingRecord4ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func NextPageBtnOnTap(_ sender: Any) {
        //firebase setup
        let ref = Database.database().reference()
        if Auth.auth().currentUser != nil {
        let user = Auth.auth().currentUser
        if let user = user {
        if BICEPS == true{
            ref.child("User_Challenge_Selection").child(user.uid).setValue(["BodyPart": "BICEPS" as NSString,"Time_Limit":TimeLabel.text!])
            //TO next page
            toTrainBRecord()
        }else if TRICEPS == true{
            
            ref.child("User_Challenge_Selection").child(user.uid).setValue(["BodyPart": "TRICEPS" as NSString,"Time_Limit":TimeLabel.text!])
            //To next page
            toTrainTRecord()
        }else if CHEST == true{
            
            ref.child("User_Challenge_Selection").child(user.uid).setValue(["BodyPart": "CHEST" as NSString,"Time_Limit":TimeLabel.text!])
            //To next page
            toTrainCRecord()
        }else if BACK == true{
            
            ref.child("User_Challenge_Selection").child(user.uid).setValue(["BodyPart": "BACK" as NSString,"Time_Limit":TimeLabel.text!])
            //To next page
            toTrainBARecord()
        }else{
            showAlertError()
        }
    }
    }
    }
}
