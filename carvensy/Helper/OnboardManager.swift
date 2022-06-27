//
//  OnboardManager.swift
//  carvensy
//
//  Created by Kevin Gosalim on 26/06/22.
//

import Foundation

 class OnboardManager {
     static let shared = OnboardManager()

     var isDoneOnboarding: Bool {
         get {
             !UserDefaults.standard.bool(forKey: #function)
         }
         set {
             UserDefaults.standard.setValue(newValue, forKey: #function)
         }
     }
 }
