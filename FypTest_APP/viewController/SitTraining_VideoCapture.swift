//
//  SitTraining_VideoCapture.swift
//  FypTest_APP
//
//  Created by kin ming ching on 3/5/2022.
//
import Foundation
import AVFoundation
import UIKit

class SitTraining_VideoCapture:NSObject {
    
    
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    
    let sitTraining_Predictor = SitTraining_Predictor()
    override init() {
        super.init()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else{return}
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        captureSession.addInput(input)
        
        captureSession.addOutput(videoOutput)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        }
    func startCaptureSession(){
        captureSession.startRunning()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label:"videoDispatchQueue"))
    }
    }


extension SitTraining_VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput( _ output: AVCaptureOutput, didOutput sampleBuffer:CMSampleBuffer, from connection: AVCaptureConnection) {
        sitTraining_Predictor.estmation(sampleBuffer: sampleBuffer)
    }
}
