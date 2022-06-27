//
//  StretchCamController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 21/06/22.
//

import UIKit
import AVFoundation
import Vision

//buat nentuin skrg posenya apa
enum handPose
{
    case push_out
    case prayer
    case stop
    case thumb_glide
}


class StretchCamController: UIViewController {
    
    @IBOutlet weak var stretchInstructionView: UIView!
    @IBOutlet weak var stretchRepsView: UIView!
    @IBOutlet weak var stretchGuideGifCam: UIImageView!
    @IBOutlet weak var stretchTitleCam: UILabel!
    @IBOutlet weak var stretchDescCam: UITextView!
    @IBOutlet weak var stretchRepsCam: UILabel!
    @IBOutlet weak var stretchHoldTimer: TimerProgressBar!
    @IBOutlet weak var repsProgress: RepsProgress!
    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    private var cameraView: CameraView { view as! CameraView }
    private var cameraFeedSession: AVCaptureSession?
    var currentPose: handPose = .push_out
    var countRep = 0
    var countDown = 0
    var canCount = false

    var totalDuration: Double = 0
    var stretchPlan: Int? 

    var stretchStep : StretchSteps?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stretchInstructionView.roundViewCorner(UIRectCorner.allCorners, radius: 20.0)
        stretchInstructionView.layer.opacity = 0.7
        stretchRepsView.roundViewCorner(UIRectCorner.allCorners, radius: 20.0)
        stretchRepsView.layer.opacity = 0.7
        
        stretchTitleCam.text = stretchStep?.stretchTitle
        let gifImage = UIImage.gifImageWithName(stretchStep?.stretchIcon ?? "nothing")
        stretchGuideGifCam.image = gifImage
        stretchDescCam.text = stretchStep?.stretchDesc
        
        stretchRepsCam.text = "Reps"
        
        repsProgress.progress = "\(countRep + 1) / \(stretchStep?.numberofReps ?? 5)"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            if cameraFeedSession == nil {
                cameraView.previewLayer.videoGravity = .resizeAspectFill
                try setupAVSession()
                cameraView.previewLayer.session = cameraFeedSession
            }
            cameraFeedSession?.startRunning()
        } catch {
            AppError.display(error, inViewController: self)
        }
        
        stretchRepsCam.text = "Hold"
        repsProgress.isHidden = true
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
            else {fatalError("Can't detect hand")}
        
        let defaultConfig = MLModelConfiguration()
        guard let model = try? HandModel(configuration: defaultConfig)
        else{
            fatalError("Model not found")
        }
                
        
       guard let handPrediction = try? model.prediction(poses: keyPointMultiArray)
        else
        {
           fatalError("Can't make hand prediction")
        }
        
        let confidence = handPrediction.labelProbabilities[handPrediction.label]!
        
        if confidence > 0.8
        {
            //fungsi hold still + tambah reps
        }
    }
    
    func stretch(pose: String)
    {
        switch currentPose
        {
            case .push_out:
            
            if pose == "Push Out"
            {
                //kasi tau hold still
                if canCount
                {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                        DispatchQueue.main.async {
                            self.countDown += 1
                            
                            if self.countDown == self.stretchStep?.holdSec
                            {
                                timer.invalidate()
                                self.countRep += 1
                                self.countDown = 0
                                
                                if self.countRep == self.stretchStep?.numberofReps
                                {
                                    self.performSegue(withIdentifier: "goBackToSteps", sender: self)
                                }
                                
                                else
                                {
                                    self.canCount = false
                                }
                            }
                        }
                    }
                }
                
                
            }
            
            else
            {
                //kasi tau kalau salah gerakan
            }
           
            case .prayer:
            
            if pose == "Prayer"
            {
                //kasi tau hold still
                if canCount
                {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                        DispatchQueue.main.async {
                            self.countDown += 1
                            
                            if self.countDown == self.stretchStep?.holdSec
                            {
                                timer.invalidate()
                                self.countRep += 1
                                self.countDown = 0
                                
                                if self.countRep == self.stretchStep?.numberofReps
                                {
                                    self.performSegue(withIdentifier: "goBackToSteps", sender: self)
                                }
                                
                                else
                                {
                                    self.canCount = false
                                }
                            }
                        }
                    }
                }
            }
            
            else
            {
                //kasi tau kalau salah gerakan
            }
            
            case .stop:
            
            if pose == "Stop"
            {
                //kasi tau hold still
                if canCount
                {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                        DispatchQueue.main.async {
                            self.countDown += 1
                            
                            if self.countDown == self.stretchStep?.holdSec
                            {
                                timer.invalidate()
                                self.countRep += 1
                                self.countDown = 0
                                
                                if self.countRep == self.stretchStep?.numberofReps
                                {
                                    self.performSegue(withIdentifier: "goBackToSteps", sender: self)
                                }
                                
                                else
                                {
                                    self.canCount = false
                                }
                            }
                        }
                    }
                }
            }
            
            else
            {
                //kasi tau kalau salah gerakan
            }
            
            case .thumb_glide:
            
            if pose == "Thumb Glide"
            {
                //kasi tau hold still
                if canCount
                {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                        DispatchQueue.main.async {
                            self.countDown += 1
                            
                            if self.countDown == self.stretchStep?.holdSec
                            {
                                timer.invalidate()
                                self.countRep += 1
                                self.countDown = 0
                                
                                if self.countRep == self.stretchStep?.numberofReps
                                {
                                    let sessionHelper = SessionCRUD()
                                    
                                    let sessions = sessionHelper.fetchSession()
                                    
                                    if sessions.count != 0
                                    {
                                        let currentSession = sessions.first
                                        
                                        if currentSession?.stretch == nil
                                        {
                                            sessionHelper.firstStretch(Current_session: currentSession!, duration: self.totalDuration, plan: Double(self.stretchPlan ?? 0))
                                        }
                                        else
                                        {
                                            sessionHelper.addStretch(Current_session: currentSession!, duration: self.totalDuration, plan: Double(self.stretchPlan ?? 0))
                                        }
                                        self.performSegue(withIdentifier: "stretchEnd", sender: self)
                                    }
                                    
                                    else
                                    {
                                        fatalError("Session not found")
                                    }
                                    
                                }
                                
                                else
                                {
                                    self.canCount = false
                                }
                            }
                        }
                    }
                }
            }
            
            else
            {
                //kasi tau kalau salah gerakan
            }
            
        }
    }
    
}
