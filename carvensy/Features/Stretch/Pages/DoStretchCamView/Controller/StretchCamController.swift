//
//  StretchCamController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 21/06/22.
//

import UIKit
import AVFoundation
import Vision


class StretchCamController: UIViewController {
    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    private var cameraFeedSession: AVCaptureSession?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            if cameraFeedSession == nil {
                try setupAVSession()
            }
            cameraFeedSession?.startRunning()
        } catch {
            AppError.display(error, inViewController: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    func setupAVSession() throws {
        // Input kamera depan
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw AppError.captureSessionSetup(reason: "Could not find a front facing camera.")
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw AppError.captureSessionSetup(reason: "Could not create video device input.")
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        //tambah input video
        guard session.canAddInput(deviceInput) else {
            throw AppError.captureSessionSetup(reason: "Could not add video device input to the session")
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
                //tambah video output
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw AppError.captureSessionSetup(reason: "Could not add video data output to the session")
        }
        session.commitConfiguration()
        cameraFeedSession = session
}
    
}

extension StretchCamController: AVCaptureVideoDataOutputSampleBufferDelegate
{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        //buat hand pose request
        let handPoseRequest = VNDetectHumanHandPoseRequest()
        
        //image handler
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, options: [:])
        
        do
        {
            try handler.perform([handPoseRequest])
            
        }
        
        catch
        {
            assertionFailure("Hand Pose Request Failed: \(error)")
        }
        
        //kalau ga ada tangan yang terdeteksi
        guard let observation = handPoseRequest.results, !observation.isEmpty else
        {
            //bikin warning klo no hand detected
            return
        }
        
        //ambil handpose pertama yang terdeteksi
        let handPose = observation.first
        
        //dapetin key point dari posenya
        guard let keyPointMultiArray = try? handPose?.keypointsMultiArray()
            else {fatalError()}
        
        let defaultConfig = MLModelConfiguration()
        guard let model = try? HandModel(configuration: defaultConfig)
        else{
            fatalError()
        }
                
        
       guard let handPrediction = try? model.prediction(poses: keyPointMultiArray)
        else
        {
           fatalError()
       }
        
        let confidence = handPrediction.labelProbabilities[handPrediction.label]!
        
        if confidence > 0.8
        {
            //fungsi hold still + tambah reps
        }
    }
}
