//
//  NotificationHelper.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 22/06/22.
//

import UIKit
import UserNotifications

func scheduleNotification(title: String, content: String, timeInterval: Double) -> UNNotificationRequest
{
    let notif = UNMutableNotificationContent()
    notif.title = title
    notif.body = content
    
    //notif trigger
    let date = Date().addingTimeInterval(timeInterval)
    
    let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
    
    //notif request
    let uuid = UUID().uuidString
    
    let request = UNNotificationRequest(identifier: uuid, content: notif, trigger: trigger)
    
    //register notif request
    
    return request
}

