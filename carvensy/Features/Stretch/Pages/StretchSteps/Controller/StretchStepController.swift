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

    var index = 0
    
    var isPaused = false
    var countFired: CGFloat =  10
    
    override func viewWillAppear(_ animated: Bool) {
//        setSteps()
        progressBar.progress = 1
        countDown()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setSteps()
       
        // Do any additional setup after loading the view.
    }
    
    private func setSteps()
    {
        numberOfSteps.text = "Stretch \(index + 1) of \(stretchStepArray.count)"
        stretchTitle.text = stretchStepArray[index].stretchTitle
        stretchGuideGif.image = UIImage(data: stretchStepArray[index].stretchIcon!)
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
                        //pindah ke halaman doStretch
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
            //pindah ke daily summary ??
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            alert.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
