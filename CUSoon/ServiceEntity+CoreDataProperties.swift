//
//  ServiceEntity+CoreDataProperties.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/12/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation
import CoreData


extension ServiceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServiceEntity> {
        return NSFetchRequest<ServiceEntity>(entityName: "ServiceEntity");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var range: Double
    @NSManaged public var service_type: Int16
    @NSManaged public var message: String?
    @NSManaged public var phone: String?
    @NSManaged public var name: String?
    @NSManaged public var title: String?

}
