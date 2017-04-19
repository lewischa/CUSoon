//
//  ServiceRunning+CoreDataProperties.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/18/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation
import CoreData


extension ServiceRunning {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServiceRunning> {
        return NSFetchRequest<ServiceRunning>(entityName: "ServiceRunning");
    }

    @NSManaged public var isRunning: Bool
    @NSManaged public var id: Int16

}
