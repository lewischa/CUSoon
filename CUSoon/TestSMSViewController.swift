//
//  TestSMSViewController.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/22/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import UIKit
import UserNotifications

class TestSMSViewController: UIViewController {
    
    @IBOutlet weak var toNumber: UITextField!
    @IBOutlet weak var msg: UITextField!
    
    let handler = SMSHandler()
    let serviceHandler = ServiceHandler(ServiceModel(lat: 38.472681, long: -122.760275, _range: 5.0, sType: 2, _title: "Test1", msg: "msg1", _phone: "7072922477", _name: "Chad1"))

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = (self as UNUserNotificationCenterDelegate)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func testSMS() {
        let sms = SMSModel(to: toNumber.text!, body: msg.text!)
        handler.sendSMS(sms: sms)
    }
    
    @IBAction func notification() {
//        alarmHandler.play()
        serviceHandler.fire()
        
    }
}


extension TestSMSViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("here")
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
