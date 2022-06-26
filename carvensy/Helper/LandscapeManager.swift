//
//  LandscapeManager.swift
//  carvensy
//
//  Created by Kevin Gosalim on 26/06/22.
//

import Foundation

 class LandscapeManager {
     static let shared = LandscapeManager()

     var isFirstLaunch: Bool {
         get {
             !UserDefaults.standard.bool(forKey: #function)
         }
         set {
             UserDefaults.standard.setValue(newValue, forKey: #function)
         }
     }
 }
