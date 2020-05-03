//
//  Date.swift
//  TestProject
//
//  Created by Cristian Barril on May 03, 2020.
//  Copyright © 2020 Cristian Barril. All rights reserved.
//

import Foundation

extension Date {
    
    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func getPastTimeString() -> String {
        guard var distance = self.totalDistance(from: Date(), resultIn: .minute) else {
            return ""
        }
        
        guard distance > 0 else {
            return "now"
        }
        
        distance *= distance < 0 ? -1 : 1
        let hour = 60
        let day = 1440
        
        switch distance {
        case let value where value < hour:
            let mins = value
            return mins == 1 ? "\(mins) min ago" : "\(mins) mins ago"
        case let value where hour...day ~= value:
            let hours = value/hour
            return hours == 1 ? "\(hours) hour ago" : "\(hours) hours ago"
        default:
            let days = distance/day
            return days == 1 ? "\(days) day ago" : "\(days) days ago"
        }
    }
}
