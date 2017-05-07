//
//  CLLocationCoordinate2DExtension.swift
//  CUSoon
//
//  Created by Chad Lewis on 5/6/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension CLLocation {
    func degreeToRadian(degree: CLLocationDegrees) -> CGFloat {
        return ((CGFloat(degree) / 180.0 * CGFloat(Double.pi)))
    }
    
    func radianToDegree(radian: CGFloat) -> CLLocationDegrees {
        return CLLocationDegrees(radian * CGFloat(180.0 / Double.pi))
    }
    
    func midPoint(destination: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        var x = CGFloat(0.0)
        var y = CGFloat(0.0)
        var z = CGFloat(0.0)
        
        var latitude: CGFloat = degreeToRadian(degree: self.coordinate.latitude)
        var longitude: CGFloat = degreeToRadian(degree: self.coordinate.longitude)
        
        x = cos(latitude) * cos(longitude)
        y = cos(latitude) * sin(longitude)
        z = sin(latitude)
        
        latitude = degreeToRadian(degree: destination.latitude)
        longitude = degreeToRadian(degree: destination.longitude)
        
        x = x + cos(latitude) * cos(longitude)
        y = y + cos(latitude) * sin(longitude)
        z = z + sin(latitude)
        
        x = x / CGFloat(2)
        y = y / CGFloat(2)
        z = z / CGFloat(2)
        
        let newLon: CGFloat = atan2(y, x)
        let newHyp: CGFloat = sqrt(x * x + y * y)
        let newLat: CGFloat = atan2(z, newHyp)
        
        let resultLat = radianToDegree(radian: newLat)
        let resultLon = radianToDegree(radian: newLon)
        
        let result: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: resultLat, longitude: resultLon)
        
        return result
    }
}
