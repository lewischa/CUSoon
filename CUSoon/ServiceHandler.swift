//
//  ServiceHandler.swift
//  CUSoon
//
//  Created by:
//      Brooke Borges
//      Chad Lewis
//      Jeremy Olsen
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation
import UserNotifications

class ServiceHandler: NSObject {
    let content: UNMutableNotificationContent
    let trigger: UNTimeIntervalNotificationTrigger
    let request: UNNotificationRequest
    let sound: UNNotificationSound
    
    let service: ServiceModel
    let smsHandler: SMSHandler
    
    
    init(_ serviceToUse: ServiceModel) {
        smsHandler = SMSHandler()
        content = UNMutableNotificationContent()
        service = serviceToUse
        content.title = "CUSoon"
        content.subtitle = "Alert!"
        content.body = "Nearing destination."
        content.categoryIdentifier = "reached_dest"
        sound = UNNotificationSound(named: "piano_beat_mix.wav")
        content.sound = sound
        
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        request = UNNotificationRequest(identifier: "reached_dest", content: content, trigger: trigger)
        super.init()
    }
    
    override init() {
        service = ServiceModel()
        smsHandler = SMSHandler()
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
    
    func fire(_ timeToArrival: Double) {
        let sType = service.service_type
        if sType == 0 || sType == 2 {
            scheduleNotification()
        }
        if sType == 1 || sType == 2 {
            // send SMS
            if let number = service.phone, let message = service.message {
                smsHandler.sendSMS(sms: SMSModel(to: number, body: message, time: timeToArrival))
            }
        }
    }
}
