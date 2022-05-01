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

    private let iconImage: UIImageView = {
        let iconimage = UIImageView(frame: CGRect(x: 20, y: 125, width: 60, height: 60))
        iconimage.image = UIImage(named: "Icon_110_Biceps")
        return iconimage}()
    
    //background

    private let backgroundLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 0, y: 60, width: 414, height: 136))
        Label.backgroundColor = UIColor(red: 81/255, green: 57/255, blue: 0/255, alpha: 0.6)
        Label.bounds.origin = CGPoint(x:0, y: 30)
        Label.textColor = UIColor.white
        return Label }()
    //TEXT Label

    private let titleLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 78, y: 125, width: 122, height: 63))
        Label.text = "BICEPS\nTRAINING"
        Label.bounds.origin = CGPoint(x: 78, y:125)
        Label.numberOfLines = 2
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.white
        return Label }()
    

    private let SetSLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 348, y: 98, width: 63, height: 39))
        Label.text = "SET"
        Label.bounds.origin = CGPoint(x: 348, y: 108)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.lightGray
        return Label }()
    

    private let RepSLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 348, y: 148, width: 63, height: 39))
        Label.text = "REPS"
        Label.bounds.origin = CGPoint(x: 348, y: 148)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.lightGray
        return Label }()
    
    private let durationsLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 35, y: 80, width: 109, height: 21))
        Label.text = "DURATION"
        Label.bounds.origin = CGPoint(x: 35, y: 80)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.lightGray
        return Label }()
    //traing count
    private let totalLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 310, y: 144, width: 63, height: 44))
        Label.bounds.origin = CGPoint(x: 305, y: 144)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.white
        return Label }()
    
    private let trainsetLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 300, y: 95, width: 61, height: 44))
        Label.bounds.origin = CGPoint(x: 300, y: 95)
        Label.font = Label.font.withSize(25)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.white
        return Label }()
    
    private let trainingcLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 295, y: 126, width: 68, height: 62))
        Label.text = "0"
        Label.bounds.origin = CGPoint(x: 295, y: 126)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.font = Label.font.withSize(25)
        Label.textColor = UIColor.white
        return Label }()
    //time
    private let durationLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 40, y: 95, width: 88, height: 24))
        Label.text = "08:00"
        Label.font = Label.font.withSize(20)
        Label.bounds.origin = CGPoint(x: 30, y: 60)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.white
        return Label }()
    
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
            self.totalLabel.text = "/\(actionamount)"
            self.trainingcLabel.text = "\(self.TrainSetCount)"
            self.trainsetLabel.text = "\(self.TrainSetCount)/\(TrainSetAmount)"
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
        //display top bar of user information
        view.addSubview(iconImage)
        view.addSubview(backgroundLBL)
        view.addSubview(titleLBL)
        view.addSubview(SetSLBL)
        view.addSubview(RepSLBL)
        view.addSubview(durationsLBL)
        view.addSubview(totalLabel)
        view.addSubview(trainsetLabel)
        view.addSubview(trainingcLabel)
        view.addSubview(durationLabel)
    }
}

extension ViewController: PredictorDelegte{
    func predictor(predictor: Predictor, didLableAction action: String, with confience: Double) {
        print("Detected: \(action),Confidence: \(confience)")
        if action == "BicepsCorrect" && confience > 0.70 && isThrowDetected == false{
            
            print("Throw detected")
            isThrowDetected = true

            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                self.isThrowDetected = false
            }
            DispatchQueue.main.async {
                //upload label
                self.trainingcLabel.text = String(self.Actioncount)
                self.trainsetLabel.text = "\(self.TrainSetCount)/\(String(self.User_TrainSetAmount))"
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

