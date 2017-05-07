//
//  SMSModel.swift
//  CUSoon
//
//  Created by:
//      Brooke Borges
//      Chad Lewis
//      Jeremy Olsen
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation

struct SMSModel {
    var number: String?
    var message: String
    let cusoonResponse: String
//    "Sent from CUSoon."
    
    init(to: String, body: String, time: Double) {
        cusoonResponse = "Sent from CUSoon app."
        if to.characters.count == 10 {
            number = "%2B1"
            number! += to
        } else {
            number = nil
        }
        message = body
        if message != "" {
            message += " - "
        }
        message += "\(time) minutes until arrival - "
        message += cusoonResponse
    }
    
    
    func toNumber() -> String? {
        return self.number
    }
    
    func body() -> String {
        return self.message
    }
}


extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
