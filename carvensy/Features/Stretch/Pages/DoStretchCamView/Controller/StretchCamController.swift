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
enum handPose : String
{
    case push_out = "Push Out"
    case prayer = "Prayer"
    case stop = "Stop"
    case thumb_glide = "Thumb Glide"
}


class StretchCamController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{
    
    @IBOutlet weak var stretchInstructionView: UIView!
    @IBOutlet weak var stretchWarning: UIView!
    @IBOutlet weak var warningText: UILabel!
    @IBOutlet weak var stretchRepsView: UIView!
    @IBOutlet weak var stretchGuideGifCam: UIImageView!
    @IBOutlet weak var stretchTitleCam: UILabel!
    @IBOutlet weak var stretchDescCam: UITextView!
    @IBOutlet weak var stretchRepsCam: UILabel!
    @IBOutlet weak var stretchDoneBtn: UIButton!
    @IBOutlet weak var stretchHoldTimer: TimerProgressBar!
    @IBOutlet weak var repsProgress: RepsProgress!
    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    private var cameraView: CameraView { view as! CameraView }
    private var cameraFeedSession: AVCaptureSession?
    var currentPose: handPose = .push_out
    var failCount = 0
    var countRep = 0
    var countDown = 0
    var canCount = false
    var totalDuration: Double = 0
    var stretchPlan: Int? 

    var stretchStep : StretchSteps?
    
    var delegate : passData?
    
    var scheduleTimer: Timer!
    
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
        
        stretchHoldTimer.progress = 1
        countDown = stretchStep?.holdSec ?? 5
        stretchHoldTimer.maxDuration = stretchStep?.holdSec ?? 5
        
        stretchRepsCam.text = "Reps"
        stretchWarning.layer.opacity = 0
        
        stretchDoneBtn.isHidden = true
        
        repsProgress.progress = "\(countRep) / \(stretchStep?.numberofReps ?? 2)"
        
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func failedToDetect(_ sender: Any)
    {
        if currentPose == .push_out || currentPose == .prayer || currentPose == .stop
        {
            self.delegate?.pass(data: 1)
            self.dismiss(animated: true)
        }
        
        else
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
            DispatchQueue.main.sync
            {
                self.stretch(pose: handPrediction.label)
                
            }
            
            
        }
        
    }
    
    func wakeWarning(message: String)
    {
    
        warningText.text = message
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) {
            self.stretchWarning.layer.opacity = 1
        } completion: { done in
            if done
            {
                UIView.animate(withDuration: 1, delay: 5, options: .curveEaseOut) {
                    self.stretchWarning.layer.opacity = 0
                }
            }
        }

    }
    
    
    func stretch(pose: String)
    {
        switch currentPose
        {
            case .push_out:
            
            if pose == "Push Out"
            {
                canCount = true
                wakeWarning(message: "Pose detected! Please hold your position")
                stretchRepsCam.text = "Hold"
                repsProgress.isHidden = true
                
                if canCount
                {
                    if scheduleTimer != nil
                    {
                        scheduleTimer.invalidate()
                    }
                    scheduleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in

                        DispatchQueue.main.async {

                            self.countDown -= 1
                            print(self.countDown)
                            self.stretchHoldTimer.progress = min(0.2 * CGFloat(self.countDown), 1)

                            if self.countDown == 0
                            {
                                if self.scheduleTimer != nil
                                {
                                    self.scheduleTimer.invalidate()
                                }
                                self.countRep += 1
                                self.countDown = self.stretchStep?.holdSec ?? 5
                                self.stretchHoldTimer.progress = 1
                                self.repsProgress.progress = "\(self.countRep) / \(self.stretchStep?.numberofReps ?? 2)"
                                self.repsProgress.textLayer.string = self.repsProgress.progress
                                self.stretchRepsCam.text = "Reps"
                                self.repsProgress.isHidden = false

                                if self.countRep == self.stretchStep?.numberofReps
                                {
                                    self.delegate?.pass(data: 1)
                                    self.dismiss(animated: true)
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
                if failCount < 75
                {
                    wakeWarning(message: "Pose not detected! Try again!")
                    failCount += 1
                }
                
                else
                {
                    wakeWarning(message: "Pose not detected! Try again!")
                    stretchDoneBtn.isHidden = false
                }
                
            }
           
            case .prayer:
            
            if pose == "Prayer"
            {
                canCount = true
                wakeWarning(message: "Pose detected! Please hold your position")
                stretchRepsCam.text = "Hold"
                repsProgress.isHidden = true
                
                if canCount
                {
                    if scheduleTimer != nil
                    {
                        scheduleTimer.invalidate()
                    }
                    scheduleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                        DispatchQueue.main.async {
                            self.countDown -= 1
                            print(self.countDown)
                            self.stretchHoldTimer.progress = min(0.2 * CGFloat(self.countDown), 1)
                            
                            if self.countDown == 0
                            {
                                if self.scheduleTimer != nil
                                {
                                    self.scheduleTimer.invalidate()
                                }
                                self.countRep += 1
                                self.countDown = self.stretchStep?.holdSec ?? 5
                                self.stretchHoldTimer.progress = 1
                                self.repsProgress.progress = "\(self.countRep) / \(self.stretchStep?.numberofReps ?? 2)"
                                print(self.countRep)
                                self.stretchRepsCam.text = "Reps"
                                self.repsProgress.isHidden = false
                                
                                if self.countRep == self.stretchStep?.numberofReps
                                {
                                    self.delegate?.pass(data: 1)
                                    self.dismiss(animated: true)
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
                    if failCount < 75
                    {
                        wakeWarning(message: "Pose not detected! Try again!")
                        failCount += 1
                    }
                    
                    else
                    {
                        wakeWarning(message: "Pose not detected! Try again!")
                        stretchDoneBtn.isHidden = false
                    }
            }
            
            case .stop:
            
            if pose == "Stop"
            {
                canCount = true
                wakeWarning(message: "Pose detected! Please hold your position")
                stretchRepsCam.text = "Hold"
                repsProgress.isHidden = true
                
                if canCount
                {
                    if scheduleTimer != nil
                    {
                        scheduleTimer.invalidate()
                    }
                    scheduleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                        DispatchQueue.main.async {
                            self.countDown -= 1
                            print(self.countDown)
                            self.stretchHoldTimer.progress = min(0.2 * CGFloat(self.countDown), 1)
                            
                            if self.countDown == 0
                            {
                                if self.scheduleTimer != nil
                                {
                                    self.scheduleTimer.invalidate()
                                }
                                self.countRep += 1
                                self.countDown = self.stretchStep?.holdSec ?? 5
                                self.stretchHoldTimer.progress = 1
                                print(self.countRep)
                                self.repsProgress.progress = "\(self.countRep) / \(self.stretchStep?.numberofReps ?? 2)"
                                self.stretchRepsCam.text = "Reps"
                                self.repsProgress.isHidden = false
                                
                                if self.countRep == self.stretchStep?.numberofReps
                                {
                                    self.delegate?.pass(data: 1)
                                    self.dismiss(animated: true)
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
                    if failCount < 75
                    {
                        wakeWarning(message: "Pose not detected! Try again!")
                        failCount += 1
                    }
                    
                    else
                    {
                        wakeWarning(message: "Pose not detected! Try again!")
                        stretchDoneBtn.isHidden = false
                    }
            }
            
            case .thumb_glide:
            
            if pose == "Thumb Glide"
            {
                canCount = true
                wakeWarning(message: "Pose detected! Please hold your position")
                stretchRepsCam.text = "Hold"
                repsProgress.isHidden = true
                
                if canCount
                {
                    if scheduleTimer != nil
                    {
                        scheduleTimer.invalidate()
                    }
                    scheduleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                        DispatchQueue.main.async {
                            self.countDown -= 1
                            print(self.countDown)
                            self.stretchHoldTimer.progress = min(0.2 * CGFloat(self.countDown), 1)
                            
                            if self.countDown == 0
                            {
                                if self.scheduleTimer != nil
                                {
                                    self.scheduleTimer.invalidate()
                                }
                                self.countRep += 1
                                self.countDown = self.stretchStep?.holdSec ?? 5
                                self.stretchHoldTimer.progress = 1
                                self.repsProgress.progress = "\(self.countRep) / \(self.stretchStep?.numberofReps ?? 2)"
                                print(self.countRep)
                                self.stretchRepsCam.text = "Reps"
                                self.repsProgress.isHidden = false
                                
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
                    if failCount < 75
                    {
                        wakeWarning(message: "Pose not detected! Try again!")
                        failCount += 1
                    }
                    
                    else
                    {
                        wakeWarning(message: "Pose not detected! Try again!")
                        stretchDoneBtn.isHidden = false
                    }
            }
            
        }
    }
    
}

