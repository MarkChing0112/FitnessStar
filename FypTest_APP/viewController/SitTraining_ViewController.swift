//
//  SitTraining_ViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 3/5/2022.
//
import UIKit
import AVFoundation
import AudioToolbox
import Firebase
import FirebaseAuth

class SitTraining_ViewController: UIViewController {
    
    let SitTraining_videoCapture = SitTraining_VideoCapture()
    var previewLayer: AVCaptureVideoPreviewLayer?
    //user data and user train amount count
    public var User_ActionAmount: Int = 0
    public var User_TrainSetAmount: Int = 0
    var TrainSetCount: Int = 0
    var Actioncount: Int = 0
    var Accuracy_STR : String = ""
   
    @IBOutlet weak var Camera_View: UIView!
    
    @IBOutlet weak var Objectview: UIView!
    @IBOutlet weak var durationcLBL: UILabel!
    @IBOutlet weak var TrainingSetCountLBL: UILabel!
    @IBOutlet weak var ActionCountLBL: UILabel!
    @IBOutlet weak var ActionTotalLBL: UILabel!
    @IBOutlet weak var TitleLBL: UILabel!
    var pointLayer = CAShapeLayer()
    //time
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MM/dd/yyyy-HH:mm:a"
        return formatter
    }()
    let formatter2: DateFormatter = {
        let formatter2 = DateFormatter()
        formatter2.timeZone = .current
        formatter2.locale = .current
        formatter2.dateFormat = "MM-dd-yyyy-HH:mm:a"
        return formatter2
    }()

    
    var isThrowDetected = false
    override func viewDidLoad() {
        super.viewDidLoad()

        //get firebase data
        Read_Data()
        //setup camera
        setupVideoPreview()
        //pose detection
        SitTraining_videoCapture.sitTraining_Predictor.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        StopTimer()
    }
    //time count
    var timer:Timer = Timer()
    var Time_S : Int = 0
    var timerCounting:Bool = false
    
    func StopTimer(){
        timer.invalidate()
    }
    @objc func timeCounter() -> Void{
        Time_S += 1
        let time = secondsToMinutesSconds(seconds: Time_S)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        self.durationcLBL.text = timeString
    }
    
    func timerc(){
        if(TrainSetCount != User_TrainSetAmount && User_ActionAmount != Actioncount){
            timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timeCounter),
            userInfo: nil,
            repeats: true)
        }else if(TrainSetCount == User_TrainSetAmount && Actioncount == 0){
            timer.invalidate()
        }
    }
    
    func secondsToMinutesSconds(seconds: Int) -> (Int,Int){
        return (((seconds%3600)/60),((seconds % 3600)%60))
    }
    
    func makeTimeString(minutes: Int, seconds : Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
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

            let U_ActionAmount = (actionamount as NSString).integerValue
            let U_TrainSetAmount = (TrainSetAmount as NSString).integerValue
            self.User_TrainSetAmount = U_TrainSetAmount
            self.User_ActionAmount = U_ActionAmount
            self.ActionTotalLBL.text = "/\(actionamount)"
            self.ActionCountLBL.text = "\(self.TrainSetCount)"
            self.TrainingSetCountLBL.text = "\(self.TrainSetCount)/\(TrainSetAmount)"
          // ...
        }) { error in
          print(error.localizedDescription)
            }}
    }

    func toRecordPage(){
        let recordTableViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.recordTableViewController) as? RecordTableViewController
        self.navigationController?.pushViewController(recordTableViewController!, animated: true)
    }
    
    func Check_amount(){

        let user = Auth.auth().currentUser
        //check the user action equal the user amount setting
        if let user = user {
            if((Actioncount<User_ActionAmount)&&(TrainSetCount != User_TrainSetAmount)){
                Actioncount += 1
                ActionCountLBL.text = "\(Actioncount)"
                if((Actioncount == User_ActionAmount)&&(TrainSetCount < User_TrainSetAmount)){
                    TrainSetCount += 1
                    Actioncount = 0
                    ActionCountLBL.text = "\(Actioncount)"
                    TrainingSetCountLBL.text = "\(TrainSetCount)/\(String(User_TrainSetAmount))"
                    if((TrainSetCount == User_TrainSetAmount)){
                    //show alert & save data to firebase
                        let db = Firestore.firestore()
                        let date = Date()
                        let time1 = formatter.string(from: date)
                        let time2 = formatter2.string(from: date)
                        let total_User_Train = User_ActionAmount * User_TrainSetAmount
                        db.collection("Record").document(user.uid).collection("data").document("\(self.TitleLBL.text!) \(String(time2))").setData([
                                    "lastUpdated":time1,
                                    "GymType": self.TitleLBL.text!,
                                    "Accuracy": self.Accuracy_STR,
                                    "User_Train_Set": self.TrainSetCount,
                                    "User_Train_Amount": total_User_Train,
                                    "User_Time": self.durationcLBL.text!
                                ])
                            //show alertf
                            showAlertF()
                    }
                }
            }
        }
    }
    
    func showAlertF(){
        let alert = UIAlertController(title: "Fininsh Training", message: "did you want to check your Record?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sure!", style: .default, handler: {action in self.toRecordPage()}))
        alert.addAction(UIAlertAction(title: "no!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    //test function
    func Add_Amount(){
        Actioncount+=1
    }
    //preview
    private func setupVideoPreview(){
        SitTraining_videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: SitTraining_videoCapture.captureSession)
        
        guard let previewLayer = previewLayer else {
            return }
        
        Camera_View.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(pointLayer)
        pointLayer.frame = view.frame
        pointLayer.strokeColor = UIColor.green.cgColor
        
        //timer
        timerc()
    }
}

extension SitTraining_ViewController: SitTrainingDelegte{
    func SitTraining(SitTraining_predictor: SitTraining_Predictor, didLableAction action: String, with confience: Double) {
        print("Detected: \(action),Confidence: \(confience)")
        print("\(TrainSetCount) && Action Count\(Actioncount)")
        if action == "BicepsCorrect" && confience > 0.75 && isThrowDetected == false{
            
            print("Throw detected")
            isThrowDetected = true
            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                self.isThrowDetected = false
            }
            DispatchQueue.main.async {
                //get confience
                self.Accuracy_STR = "\(String(format: "%.2f",confience * 100)) %"
                //when detected alert
                AudioServicesPlayAlertSound(SystemSoundID(1331))
                //upload label
                self.Check_amount()
            }
        }
    }
    
    func SitTraining(SitTraining_predictor: SitTraining_Predictor, didFindNewRecognizedPoints point: [CGPoint]) {
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
