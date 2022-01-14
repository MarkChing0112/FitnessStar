//
//  predictor.swift
//  FypTest_APP
//
//  Created by TLok  on 21/9/2021.
//

import Foundation
import Vision

typealias ThrowingClassifies = Fyp_test_1
protocol PredictorDelegte: AnyObject {
    func predictor( predictor: Predictor,didFindNewRecognizedPoints point:[CGPoint])
    func predictor( predictor: Predictor, didLableAction action:String, with confience: Double)
}

class Predictor {
    
    weak var  delegate: PredictorDelegte?
    
    let predictionWindowSize = 30
    var posesWindow: [VNHumanBodyPoseObservation] = []
    
    init(){
        posesWindow.reserveCapacity(predictionWindowSize)
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
        guard let throwingClassifier = try? ThrowingClassifies(configuration:         MLModelConfiguration()),
              let poseMultiArray = prepareInputWithObservation( observation:posesWindow),
              let predictions = try? throwingClassifier.prediction( poses: poseMultiArray)else{ return }
        
        let label = predictions.label
        let confience = predictions.labelProbabilities[label] ?? 0
        
        delegate?.predictor(predictor: self, didLableAction: label, with: confience)
      
    }
    
    func prepareInputWithObservation( observation: [VNHumanBodyPoseObservation])-> MLMultiArray? {
        let numAvilbleFrame = observation.count
        let observationNeeded = 30
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
                    let oneFrameMultiArray = try MLMultiArray(shape:[1,3,18], dataType: .double)
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
        if posesWindow.count >= predictionWindowSize{
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
            
            delegate?.predictor(predictor: self, didFindNewRecognizedPoints: displayPoints)
        }
         catch {
            print("Error,find recognizedPoints")
        }
        
    }
}
