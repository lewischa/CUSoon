//
//  ServiceHandler.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/23/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation
import UserNotifications

class ServiceHandler: NSObject {
    let content: UNMutableNotificationContent
    let trigger: UNTimeIntervalNotificationTrigger
    let request: UNNotificationRequest
    let sound: UNNotificationSound
    
    override init() {
        sound = UNNotificationSound(named: "piano_beat_mix.wav")
        content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.subtitle = "Let's hope this works."
        content.body = "Choose your answer!"
        content.categoryIdentifier = "reached_dest"
        content.sound = sound
        
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)
        super.init()
    }
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            // handle error
        })
    }
}
