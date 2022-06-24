//
//  StretchStepController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 16/06/22.
//

import UIKit

class StretchStepController: UIViewController {

    
    @IBOutlet weak var progressBar: TimerProgressBar!
    @IBOutlet weak var numberOfSteps: UILabel!
    @IBOutlet weak var stretchTitle: UILabel!
    @IBOutlet weak var stretchGuideGif: UIImageView!
    @IBOutlet weak var stretchDesc: UITextView!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    
    var stretchStepArray = [StretchSteps]()
    var stretchChoice = 0
    var index = 0
    
    
    var isPaused = false
    var countFired: CGFloat =  10
    
    override func viewWillAppear(_ animated: Bool) {
        setSteps()
        stretchStepArray = stretchType[stretchChoice].stretchSteps
        progressBar.progress = 1
        countDown()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSteps()
        stretchStepArray = stretchType[stretchChoice].stretchSteps
        
        // Do any additional setup after loading the view.
    }
    
    private func setSteps()
    {
        numberOfSteps.text = "Stretch \(index + 1) of \(stretchStepArray.count)"
        stretchTitle.text = stretchStepArray[index].stretchTitle
        
        let gifImage = UIImage.gifImageWithName(stretchStepArray[index].stretchIcon!)
        stretchGuideGif.image = gifImage
        stretchDesc.text = stretchStepArray[index].stretchDesc
    }
    
    private func countDown()
    {
      
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                DispatchQueue.main.async {
                    
                    if !self.isPaused
                    {
                        self.countFired -= 1
                        print(self.progressBar.progress)
                        self.progressBar.progress = min(CGFloat(0.1 * self.countFired), 1)
                    }
                   
                    
                    if self.countFired == 0
                    {
                        timer.invalidate()
                        self.index += 1
                        self.performSegue(withIdentifier: "doStretchCam", sender: StretchStepController.self)
                    }
                }
            }
        
    }
    
    
    @IBAction func pauseStretch(_ sender: Any) {
        
        isPaused.toggle()
        changeBtnTitle()
        
    }
    
    private func changeBtnTitle()
    {
        if isPaused
        {
            pauseBtn.setTitle("Resume", for: .normal)
        }
        
        else
        {
            pauseBtn.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func endStretch(_ sender: Any) {
        
        isPaused = true
        changeBtnTitle()
        
        let alert = UIAlertController(title: "Are you sure?", message: "You haven't reached the end of the set. Make sure you already stretch properly before you proceed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self]_ in
            performSegue(withIdentifier: "goBackToBreak", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doStretchCam"
        {
            guard let vc = segue.destination as? StretchCamController
            else {return}
            vc.modalPresentationStyle = .fullScreen
            vc.stretchStep = stretchStepArray[index]
            
            if stretchStepArray[index].stretchTitle == "Push Out"
            {
                vc.currentPose = .push_out
            }
            
            else if stretchStepArray[index].stretchTitle == "Stop - Wrist Extension"
            {
                vc.currentPose = .stop
            }
            
            else if stretchStepArray[index].stretchTitle == "Prayer Pose"
            {
                vc.currentPose = .prayer
            }
            
            else
            {
                vc.currentPose = .thumb_glide
            }
        }
    }
  

}
