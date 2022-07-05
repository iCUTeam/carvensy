//
//  StretchStepController.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 16/06/22.
//

import UIKit

class StretchStepController: UIViewController, passData{
    
    
    
    
    @IBOutlet weak var progressBar: TimerProgressBar!
    @IBOutlet weak var numberOfSteps: UILabel!
    @IBOutlet weak var stretchTitle: UILabel!
    @IBOutlet weak var stretchGuideGif: UIImageView!
    @IBOutlet weak var stretchDesc: UITextView!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    
    var stretchType = [StretchType]()
    var stretchStepArray = [StretchSteps]()
    var dataSeeder = StretchSeeder()
    var stretchChoice = 0
    var index = 0
    
    
    var isPaused = false
    var countFired: CGFloat = 10
    
    func pass(data: Int) {
        index += data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setSteps()
        stretchStepArray = stretchType[stretchChoice].stretchSteps
        progressBar.progress = 1
        countDown()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        pauseBtn.tintColor = UIColor(red: 0.00, green: 0.44, blue: 0.38, alpha: 1.00)
        endBtn.tintColor = UIColor(red: 0.00, green: 0.44, blue: 0.38, alpha: 1.00)
        
        stretchType = dataSeeder.seedData()
        stretchStepArray = stretchType[stretchChoice].stretchSteps
        print(stretchStepArray.count)
        setSteps()
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
                        self.progressBar.progress = min(CGFloat(0.1 * self.countFired), 1)
                    }
                   
                    
                    if self.countFired == 0
                    {
                        timer.invalidate()
                        self.countFired = 10
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
        
        let alert = UIAlertController(title: "Are you sure?", message: "You haven't reached the end of the set. Make sure you already stretch properly before you proceed", preferredStyle: .alert)
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
            vc.stretchPlan = index
            vc.delegate = self
            
            if stretchStepArray[index].stretchTitle == "Push Out"
            {
                vc.currentPose = .push_out
                vc.totalDuration += stretchStepArray[index].totalDuration ?? 10
            }
            
            else if stretchStepArray[index].stretchTitle == "Wrist Extension"
            {
                vc.currentPose = .stop
                vc.totalDuration += stretchStepArray[index].totalDuration ?? 20
            }
            
            else if stretchStepArray[index].stretchTitle == "Prayer Pose"
            {
                vc.currentPose = .prayer
                vc.totalDuration += stretchStepArray[index].totalDuration ?? 10
            }
            
            else
            {
                vc.currentPose = .thumb_glide
                vc.totalDuration += stretchStepArray[index].totalDuration ?? 20
            }
        }
    }
  

}
