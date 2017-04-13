//
//  ServiceModel.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/12/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation
import CoreLocation

class ServiceModel: NSObject {
    
    let destination: CLLocationCoordinate2D
    let range: Double
    let service_type: Int16
    let title: String?
    let message: String?
    let phone: String?
    let name: String?
    
    init(service: ServiceEntity) {
        destination = CLLocationCoordinate2D(latitude: service.latitude, longitude: service.longitude)
        range = service.range
        service_type = service.service_type
        title = service.title
        message = service.message
        phone = service.phone
        name = service.name
        super.init()
    }
    
    init(lat: Double, long: Double, _range: Double, sType: Int16, _title: String, msg: String, _phone: String, _name: String) {
        destination = CLLocationCoordinate2D(latitude: lat, longitude: long)
        range = _range
        service_type = sType
        title = _title
        message = msg
        phone = _phone
        name = _name
        super.init()
    }
    
    init(dest: CLLocationCoordinate2D, _range: Double, sType: Int16, _title: String, msg: String, _phone: String, _name: String) {
        destination = dest
        range = _range
        service_type = sType
        title = _title
        message = msg
        phone = _phone
        name = _name
        super.init()
    }
    
    func printService() {
        print("lat: \(destination.latitude)")
        print("long: \(destination.longitude)")
        print("range: \(range)")
        print("service_type: \(service_type)")
        print("title: \(title)")
        print("message: \(message)")
        print("phone: \(phone)")
        print("name: \(name)")
    }
}
