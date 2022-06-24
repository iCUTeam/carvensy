//
//  MakeTimeString.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 22/06/22.
//

import Foundation

public func secondsToHourMinutesSeconds(_ ms: Int) -> (Int, Int, Int)
{
    let hour = ms/3600
    let min = (ms % 3600) / 60
    let sec = (ms % 3600) % 60
    
    return (hour, min, sec)
}

public func makeTimeString(hour: Int, min: Int, sec: Int) -> String
{
    var timeString = ""
    timeString += String(format: "%02d", hour)
    timeString += ":"
    timeString += String(format: "%02d", min)
    timeString += ":"
    timeString += String(format: "%02d", sec)
    return timeString
}

public func timeStringInHour(time: Int) -> String
{
    let curr_item = secondsToHourMinutesSeconds(time)
    
    if curr_item.0 != 0
    {
        return "\(curr_item.0) hour(s)"
    }
    
    else
    {
        return "\(curr_item.1) min(s)"
    }
}
