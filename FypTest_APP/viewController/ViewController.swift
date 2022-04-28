//
//  ViewController.swift
//  FypTest_APP
//
//  Created by TLok  on 19/9/2021.
//

import UIKit
import AVFoundation
import AudioToolbox
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    let videoCapture = VideoCapture()
    var previewLayer: AVCaptureVideoPreviewLayer?
    //user data and user train amount count
    var User_ActionAmount: Int = 0
    var User_TrainSetAmount: Int = 0
    var TrainSetCount: Int = 0
    var Actioncount: Int = 0
    
    var pointLayer = CAShapeLayer()
    //traing count
    @IBOutlet weak var Aclabel: UILabel!
    private let AcLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        Label.layer.borderWidth = 10
        Label.layer.borderColor = UIColor.white.cgColor
        return Label }()
    @IBOutlet weak var TotalActionLBL: UILabel!
    @IBOutlet weak var TrainSETLBL: UILabel!
    
    //time
    @IBOutlet weak var DurationLBL: UILabel!
    var isThrowDetected = false
    


    override func viewDidLoad() {
        super.viewDidLoad()
 
        Read_Data()
        setupVideoPreview()
        
        videoCapture.predictor.delegate = self
        
    }
    func Read_Data(){
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("User_Train_Selection").child(userID!).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? NSDictionary
            let actionamount = value?["TrainAnount"] as?  String ?? ""
            let TrainSetAmount = value?["TrainSetAmount"] as? String ?? ""

            let User_ActionAmount = Int(actionamount)!
            let User_TrainSetAmount = Int(TrainSetAmount)!
            self.TotalActionLBL.text = actionamount
            self.TrainSETLBL.text = "\(self.TrainSetCount)/\(TrainSetAmount)"
          // ...
        }) { error in
          print(error.localizedDescription)
            }}

    func toRecordPage(){
        let bicepsRecordViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.bicepsRecordViewController) as? BicepsRecordViewController
        self.view.window?.rootViewController = bicepsRecordViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func Check_amount(){
        //Set firebase var
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        //check the user action equal the user amount setting
        if let user = user {
        if ((Actioncount == User_ActionAmount) && (TrainSetCount < User_TrainSetAmount)){
            TrainSetCount += 1
            Actioncount = 0
        }else if((Actioncount<User_ActionAmount)&&(TrainSetCount != User_TrainSetAmount)){
            Actioncount += 1
        }else if((Actioncount==User_ActionAmount)&&(TrainSetCount == User_TrainSetAmount)){
            ref.child("Record").child(user.uid).setValue(["BodyPart": "BICEPS" as NSString,"TrainSetAmount": User_TrainSetAmount,"TrainAmount":User_ActionAmount])
        }
        }
        
    }
    
    func Add_Amount(){
        Actioncount+=1
    }
    
    private func setupVideoPreview(){
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        
        guard let previewLayer = previewLayer else {
            return }
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(pointLayer)
        pointLayer.frame = view.frame
        pointLayer.strokeColor = UIColor.green.cgColor
        
    

        
    }

}

extension ViewController: PredictorDelegte{
    func predictor(predictor: Predictor, didLableAction action: String, with confience: Double) {
        print("Detected: \(action),Confidence: \(confience)")
        if action == "Biceps" && confience > 0.70 && isThrowDetected == false{
            
            print("Throw detected")
            isThrowDetected = true
            DispatchQueue.main.async {
                //upload label
                self.Aclabel.text = String(self.Actioncount)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                self.isThrowDetected = false
            }
            DispatchQueue.main.async {
                //when detected alert
                self.Aclabel.backgroundColor = UIColor.green
                AudioServicesPlayAlertSound(SystemSoundID(1331))
                self.Add_Amount()
            }
        }
    }
    
    func predictor(predictor: Predictor, didFindNewRecognizedPoints point: [CGPoint]) {
        guard let previewLayer = previewLayer else {return}
        
        let convertedPoint = point.map{
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
    }
        let combinedPath = CGMutablePath()
        for point in convertedPoint{
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width:10 , height: 10))
            combinedPath.addPath(dotPath.cgPath)
        }
        
        pointLayer.path = combinedPath
        
        DispatchQueue.main.async {
            self.pointLayer.didChangeValue(for: \.path)
        }
    }
}

