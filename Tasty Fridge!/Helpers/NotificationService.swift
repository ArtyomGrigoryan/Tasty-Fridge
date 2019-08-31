//
//  NotificationService.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 31/08/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func scheduleNotification(foodShelfLife: Date, foodName: String) {
        let content = UNMutableNotificationContent()

        content.badge = 1
        content.body = foodName
        content.title = "Истёк срок годности!"
        content.sound = UNNotificationSound.default
        
        let identifier = foodName
        let components = Calendar.current.dateComponents([.year, .month, .day], from: foodShelfLife)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error is \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func requestAuthorization() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
    }
}
