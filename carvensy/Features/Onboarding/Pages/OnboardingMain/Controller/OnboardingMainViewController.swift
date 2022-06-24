//
//  OnboardingMainViewController.swift
//  carvensy
//
//  Created by Ariel Waraney on 21/06/22.
//

import UIKit

class OnboardingMainViewController: UIViewController {
    
    @IBOutlet weak var swipeArea: UIView!
    @IBOutlet weak var introductionCV: UIView!
    @IBOutlet weak var inputNameCV: UIView!
    @IBOutlet weak var painAssessmentCV: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var currentPage = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refreshPageControl()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(toRight))
        //opposite direction
        swipeRight.direction = .left
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(toLeft))
        //opposite direction
        swipeLeft.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    private func refreshPageControl(){
        pageControl.currentPage = currentPage
        
        if currentPage == 0 {
            UIView.animate(withDuration: 0.5) {
                self.introductionCV.alpha = 1
                self.inputNameCV.alpha = 0
                self.painAssessmentCV.alpha = 0
            }
        } else if currentPage == 1 {
            UIView.animate(withDuration: 0.5) {
                self.introductionCV.alpha = 0
                self.inputNameCV.alpha = 1
                self.painAssessmentCV.alpha = 0
            }
        } else if currentPage == 2 {
            UIView.animate(withDuration: 0.5) {
                self.introductionCV.alpha = 0
                self.inputNameCV.alpha = 0
                self.painAssessmentCV.alpha = 1
            }
        }
    }
    
    //MARK: - Objc functions
    
    @objc func toRight(){
        //next frame
        if currentPage < pageControl.numberOfPages - 1 {
            //check if name is empty
            if currentPage == 1 {
                //user default
                if let value = UserDefaultManager.shared.defaults.value(forKey: "userName") as? String {
                    if value == "" {
                        currentPage = 1
                    } else {
                        currentPage += 1
                    }
                }
            } else {
                currentPage += 1
            }
        }
        refreshPageControl()
    }
    
    
    @objc func toLeft(){
        //previous frame
        if currentPage > 0 {
            currentPage -= 1
        }
        refreshPageControl()
    }
}
