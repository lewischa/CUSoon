//
//  ServiceRunning+CoreDataProperties.swift
//  CUSoon
//
//  Created by:
//      Brooke Borges
//      Chad Lewis
//      Jeremy Olsen
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
