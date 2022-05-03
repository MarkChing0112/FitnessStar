//
//  SitTraining_Predictor.swift
//  FypTest_APP
//
//  Created by kin ming ching on 3/5/2022.
//
import Foundation
import Vision
//AImodel biceps file
typealias ThrowingClassifies_PushUpTraining = Pushup

protocol PushUpTrainingDelegte: AnyObject {
    func PushUpTraining( pushUpTraining_predictor: PushUpTraining_Predictor,didFindNewRecognizedPoints point:[CGPoint])
    func PushUpTraining( pushUpTraining_predictor: PushUpTraining_Predictor, didLableAction action:String, with confience: Double)
}

class PushUpTraining_Predictor {
    
    weak var  delegate: PushUpTrainingDelegte?
    
    let predictionWindowSize_Sit = 60
    var posesWindow: [VNHumanBodyPoseObservation] = []
    
    init(){
        posesWindow.reserveCapacity(predictionWindowSize_Sit)
    }
    func estmation(sampleBuffer:CMSampleBuffer){
        let RequestHeadler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)
        
        let request = VNDetectHumanBodyPoseRequest(completionHandler: bodyPoseHeader)
        
        do{
            try RequestHeadler.perform([request])
        }catch{
            print("error:\(error)")
        }
        
    }
    
    func bodyPoseHeader(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNHumanBodyPoseObservation] else{return}
       
        observations.forEach {
            processObservation(observation:$0)
        }
        if let result = observations.first{
            storeObservation(observation: result)
            
            labelActionType()
        }
    }
    
    func  labelActionType(){
        guard let throwingClassifier = try? ThrowingClassifies_SitTraining(configuration:         MLModelConfiguration()),
              let poseMultiArray = prepareInputWithObservation( observation:posesWindow),
              let predictions = try? throwingClassifier.prediction( poses: poseMultiArray)else{ return }
        
        let label = predictions.label
        let confience = predictions.labelProbabilities[label] ?? 0
        
        delegate?.PushUpTraining(pushUpTraining_predictor: self, didLableAction: label, with: confience)
      
    }
    
    func prepareInputWithObservation( observation: [VNHumanBodyPoseObservation])-> MLMultiArray? {
        let numAvilbleFrame = observation.count
        let observationNeeded = 60
        var multiArryBuffer = [MLMultiArray]()
        
        for frameIndex in 0..<min( numAvilbleFrame, observationNeeded){
            let pose = observation[frameIndex]
            do {
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArryBuffer.append(oneFrameMultiArray)
            }catch{
                continue
            }
        }
        if numAvilbleFrame < observationNeeded{
            for _ in 0 ..< (observationNeeded - numAvilbleFrame) {
                do{
                    let oneFrameMultiArray = try MLMultiArray(shape:[60,3,18], dataType: .double)
                    try resetMultiArray(predictionWindow: oneFrameMultiArray)
                    multiArryBuffer.append(oneFrameMultiArray)
                }catch{
                    continue
                }
            }
        }
        return MLMultiArray(concatenating: (multiArryBuffer), axis: 0, dataType: .float)
    }
    
    func resetMultiArray( predictionWindow: MLMultiArray, with value: Double = 0.0) throws {
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }
    func storeObservation( observation: VNHumanBodyPoseObservation) {
        if posesWindow.count >= predictionWindowSize_Sit{
            posesWindow.removeFirst()
        }
        posesWindow.append(observation)
    }
    
    func processObservation( observation: VNHumanBodyPoseObservation){
         do{
            let recognizedPoints = try observation.recognizedPoints(forGroupKey: .all)
            
            let displayPoints = recognizedPoints.map{
                CGPoint(x: $0.value.x, y: 1-$0.value.y)
            }
            
            delegate?.PushUpTraining(pushUpTraining_predictor: self, didFindNewRecognizedPoints: displayPoints)
        }
         catch {
            print("Error,find recognizedPoints")
        }
        
    }
}
