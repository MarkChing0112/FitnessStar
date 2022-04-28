//
//  ViewController.swift
//  FypTest_APP

import UIKit
import AVFoundation
import AudioToolbox
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    let videoCapture = VideoCapture()
    var previewLayer: AVCaptureVideoPreviewLayer?
    //user data and user train amount count
    public var User_ActionAmount: Int = 0
    public var User_TrainSetAmount: Int = 0
    var TrainSetCount: Int = 0
    var Actioncount: Int = 0
    var pointLayer = CAShapeLayer()
    //Duration
    //image icon
    @IBOutlet weak var IconImageView: UIImageView!
    
    //background
    @IBOutlet weak var BackgroundLBL: UILabel!
    
    //TEXT Label
    @IBOutlet weak var TitleLBL: UILabel!
    
    @IBOutlet weak var SETSLBL: UILabel!
    private let SetSLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 252, y: 66, width: 68, height: 62))

        return Label }()
    @IBOutlet weak var REPSLBL: UILabel!
    private let RepSLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 252, y: 66, width: 68, height: 62))

        return Label }()
    //traing count
    @IBOutlet weak var Aclabel: UILabel!
    
    private let AcLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 252, y: 66, width: 68, height: 62))

        return Label }()
    @IBOutlet weak var TotalActionLBL: UILabel!
    
    @IBOutlet weak var TrainSETLBL: UILabel!
    
    @IBOutlet weak var TrainingCount: UILabel!
    
    //time
    @IBOutlet weak var DurationLBL: UILabel!
    var isThrowDetected = false
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get firebase data
        Read_Data()
        //setup camera
        setupVideoPreview()
        //pose detection
        videoCapture.predictor.delegate = self
        
    }
    func Read_Data(){
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        if let user = user {
            ref.child("User_Train_Selection").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? NSDictionary
            let actionamount = value?["TrainAmount"] as?  String ?? ""
            let TrainSetAmount = value?["TrainSetAmount"] as? String ?? ""

            let User_ActionAmount = Int(actionamount)
            let User_TrainSetAmount = Int(TrainSetAmount)
            self.TotalActionLBL.text = "/\(actionamount)"
            self.TrainingCount.text = "\(self.TrainSetCount)"
            self.TrainSETLBL.text = "\(self.TrainSetCount)/\(TrainSetAmount)"
          // ...
        }) { error in
          print(error.localizedDescription)
            }}
    }

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
            //show alert
            
            
        }
        }
        
    }
    func showAlertF(){
        
    }
    
    //test function
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

            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                self.isThrowDetected = false
            }
            DispatchQueue.main.async {
                //upload label
                self.Aclabel.text = String(self.Actioncount)
                self.TrainSETLBL.text = "\(self.TrainSetCount)/\(String(self.User_TrainSetAmount))"
                //when detected alert
                AudioServicesPlayAlertSound(SystemSoundID(1331))
                self.Check_amount()
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

