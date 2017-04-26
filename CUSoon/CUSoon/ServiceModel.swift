//
//  ServiceModel.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/12/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation
import CoreLocation
import Contacts

class ServiceModel: NSObject {
    let accessor = DatabaseAccessor()
    
    var destination: CLLocationCoordinate2D
    var range: Double
    var service_type: Int16
    var title: String?
    var message: String?
    var phone: String?
    var name: String?
    var address: String?
    var addingFromFavorites: Bool
    var isFavorite: Bool
    
    override init() {
        destination = CLLocationCoordinate2D()
        range = Double()
        service_type = Int16()
        title = "No Title"
        message = ""
        phone = ""
        name = ""
        address = ""
        addingFromFavorites = false
        isFavorite = false
    }
    
    init(service: ServiceEntity) {
        destination = CLLocationCoordinate2D(latitude: service.latitude, longitude: service.longitude)
        range = service.range
        service_type = service.service_type
        title = service.title
        message = service.message
        phone = service.phone
        name = service.name
        address = service.address
        addingFromFavorites = service.addingFromFavorites
        isFavorite = true
        super.init()
    }
    
    init(lat: Double, long: Double, _range: Double, sType: Int16, _title: String, msg: String, _phone: String, _name: String) {
        destination = CLLocationCoordinate2D(latitude: lat, longitude: long)
        range = _range
        service_type = sType
        if _title.isEmpty {
            title = "No Title"
        } else {
            title = _title
        }
        message = msg
        phone = _phone
        name = _name
        address = ""
        addingFromFavorites = false
        isFavorite = false
        super.init()
    }
    
    init(dest: CLLocationCoordinate2D, _range: Double, sType: Int16, _title: String, msg: String, _phone: String, _name: String) {
        destination = dest
        range = _range
        service_type = sType
        if _title.isEmpty {
            title = "No Title"
        } else {
            title = _title
        }
        
        message = msg
        phone = _phone
        name = _name
        address = ""
        addingFromFavorites = false
        isFavorite = false
        super.init()
    }
    
    init(dest: CLLocationCoordinate2D, _range: Double, sType: Int16, _title: String, msg: String, _phone: String, _name: String, addFromFavorites: Bool) {
        destination = dest
        range = _range
        service_type = sType
        if _title.isEmpty {
            title = "No Title"
        } else {
            title = _title
        }
        message = msg
        phone = _phone
        name = _name
        address = ""
        addingFromFavorites = addFromFavorites
        isFavorite = false
    }
    
    //    func checkAndSetTitle(_ titleToUse: String) {
    //        if title == "" {
    //            title = "No Title"
    //        } else {
    //            title = _title
    //        }
    //    }
    
    func printService() {
        print("lat: \(destination.latitude)")
        print("long: \(destination.longitude)")
        print("range: \(range)")
        print("service_type: \(service_type)")
        print("title: \(String(describing: title))")
        print("message: \(String(describing: message))")
        print("phone: \(String(describing: phone))")
        print("name: \(String(describing: name))")
        print("address: \(String(describing: address))")
        print("savingFromFavorites: \(addingFromFavorites)")
    }
    
    func reverseGeocode(completion: @escaping (_ address: String) -> Void) {
        let location = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            var addressToReturn = ""
            print(location)
            
            if let marks = placemarks {
                if error == nil && marks.count > 0 {
                    if let streetNumber = marks[0].subThoroughfare {
                        print("streetNumber: \(streetNumber)")
                        addressToReturn += streetNumber
                        addressToReturn += " "
                    }
                    if let street = marks[0].thoroughfare {
                        print("street: \(street)")
                        addressToReturn += street
                    }
                    addressToReturn += ", "
                    if let city = marks[0].locality {
                        print("city: \(city)")
                        addressToReturn += city
                        addressToReturn += " "
                    }
                    if let zip = marks[0].postalCode {
                        print("zip: \(zip)")
                        addressToReturn += zip
                    }
                }
            }
            completion(addressToReturn)
        })
    }
    
    func saveToFavorites() {
        reverseGeocode(completion: {(addressToUse) in
            self.address = addressToUse
            self.isFavorite = true
            self.accessor.save(service: self)
        })
    }
}













