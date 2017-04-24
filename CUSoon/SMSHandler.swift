//
//  SMSHandler.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/22/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation

struct SMSHandler {
    let twilioSID = "ACeae4999b8a8d47e98702f10a5dc2c1f4"
    let twilioSecret = "23fcc4d52aac9005c6bdf17bee90d9c1"
    let fromNumber = "%2B17077083123"
    
    func sendSMS(sms: SMSModel) {
        if let toNumber = sms.toNumber() {
            let request = NSMutableURLRequest(url: NSURL(string: "https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")! as URL)
            request.httpMethod = "POST"
            request.httpBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(sms.body())".data(using: String.Encoding.utf8)
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                print("Finished")
                if let data = data, let responseDetails = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    // Success
                    print("Response: \(responseDetails)")
                } else {
                    // Failure
                    print("Error: \(String(describing: error))")
                }
            }).resume()
        }
    }
}
