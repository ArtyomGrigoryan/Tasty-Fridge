//
//  DateFunctions.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import Foundation

func getStringFromDate(foodDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.medium
    formatter.timeStyle = DateFormatter.Style.none
    formatter.dateFormat = "dd.MM.yyyy"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let stringFromDate = formatter.string(from: foodDate)
    
    return stringFromDate
}

func getDateFromString(foodDate: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.medium
    formatter.timeStyle = DateFormatter.Style.none
    formatter.dateFormat = "dd.MM.yyyy"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dateFromString = formatter.date(from: foodDate)!
    
    return dateFromString
}

func getCurrentDateString() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.medium
    formatter.timeStyle = DateFormatter.Style.none
    formatter.dateFormat = "dd.MM.yyyy"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let currentDate = formatter.string(from: Date())
  
    return currentDate
}

func <=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
