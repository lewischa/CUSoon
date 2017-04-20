//
//  DatabaseAccessor.swift
//  CUSoon
//
//  Created by Chad Lewis on 4/12/17.
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation
import CoreData

class DatabaseAccessor: NSObject {
    
    let coreDataContext = CoreDataCommonMethods()
    
    // MARK: - Delete All
    /*
        Deletes every entity in the database
    */
    func dropTable() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServiceEntity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try coreDataContext.managedObjectContext.fetch(fetchRequest)
            let entities = results as! [ServiceEntity]
            
            for obj in entities {
                coreDataContext.managedObjectContext.delete(obj)
                coreDataContext.saveContext(coreDataContext.managedObjectContext)
            }
        } catch {
            print("Trouble deleting all")
        }
    }
    
    // MARK: - Fetch all
    /*
        Pull all entities from the database and return them as [ServiceModel]
    */
    func fetch() -> [ServiceModel] {
        var services = [ServiceModel]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServiceEntity")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fetchRequest)
            let serviceEntities = result as! [ServiceEntity]
            
            for entity in serviceEntities {
                let service = ServiceModel(service: entity)
                services.append(service)
            }
        } catch {
            print("Unable to fetch all services from data store")
            abort()
        }
        return services
    }
    
    // MARK: - isStored
    /*
        Return TRUE: service already exists in database
        Return FALSE: service does not exist in database
    */
    func isAlreadyStored(service: ServiceModel) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServiceEntity")
        
        let latPred = NSPredicate(format: "latitude == %lf", service.destination.latitude)
        let longPred = NSPredicate(format: "longitude == %lf", service.destination.longitude)
        let rangePred = NSPredicate(format: "range == %lf", service.range)
        let servPred = NSPredicate(format: "service_type == %d", service.service_type)
        let titlePred = NSPredicate(format: "title == %@", service.title!)
        let msgPred = NSPredicate(format: "message == %@", service.message!)
        let phonePred = NSPredicate(format: "phone == %@", service.phone!)
        let namePred = NSPredicate(format: "name == %@", service.name!)
        
        let compound: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [latPred, longPred, rangePred, servPred, titlePred, msgPred, phonePred, namePred])

        fetchRequest.predicate = compound
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fetchRequest)
            let services = result as! [ServiceEntity]
            
            if services.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("Unable to fetch service from data store")
            abort()
        }
        return false
    }
    
    
    // MARK: - Save(insert)
    /*
        Inserts service into database if it does not already exist
    */
    func save(service: ServiceModel) {

        if !isAlreadyStored(service: service) {
            let toInsert = NSEntityDescription.insertNewObject(forEntityName: "ServiceEntity", into: coreDataContext.backgroundContext!) as! ServiceEntity
        
            let latitude = service.destination.latitude
            toInsert.latitude = latitude as Double
            let longitude = service.destination.longitude
            toInsert.longitude = longitude as Double
        
            toInsert.range = service.range
            toInsert.service_type = service.service_type
        
            if let title = service.title {
                toInsert.title = title
            } else {
                toInsert.title = ""
            }
            if let message = service.message {
                toInsert.message = message
            } else {
                toInsert.message = ""
            }
            if let phone = service.phone {
                toInsert.phone = phone
            }
            if let name = service.name {
                toInsert.name = name
            }
            coreDataContext.saveContext()
        }
    }
    
    
    // MARK: - Update Entry
    /*
        Set all attributes of 'old' entity to 'new'
    */
    func update(old: ServiceModel, new: ServiceModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServiceEntity")
        let latPred = NSPredicate(format: "latitude == %lf", old.destination.latitude)
        let longPred = NSPredicate(format: "longitude == %lf", old.destination.longitude)
        let rangePred = NSPredicate(format: "range == %lf", old.range)
        let servPred = NSPredicate(format: "service_type == %d", old.service_type)
        let titlePred = NSPredicate(format: "title == %@", old.title!)
        let msgPred = NSPredicate(format: "message == %@", old.message!)
        let phonePred = NSPredicate(format: "phone == %@", old.phone!)
        let namePred = NSPredicate(format: "name == %@", old.name!)
        
        let compound: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [latPred, longPred, rangePred, servPred, titlePred, msgPred, phonePred, namePred])
        
        fetchRequest.predicate = compound
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fetchRequest)
            let services = result as! [ServiceEntity]
            
            if services.count > 0 {
                services[0].latitude = new.destination.latitude
                services[0].longitude = new.destination.longitude
                services[0].range = new.range
                services[0].service_type = new.service_type
                services[0].title = new.title
                services[0].message = new.message
                services[0].phone = new.phone
                services[0].name = new.name
                coreDataContext.saveContext()
            }
        } catch {
            print("Unable to fetch service to update from data store")
            abort()
        }
    }
    
    // MARK: - Delete Entry
    /*
        Remove service from database
    */
    func delete(service: ServiceModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServiceEntity")
        let latPred = NSPredicate(format: "latitude == %lf", service.destination.latitude)
        let longPred = NSPredicate(format: "longitude == %lf", service.destination.longitude)
        let rangePred = NSPredicate(format: "range == %lf", service.range)
        let servPred = NSPredicate(format: "service_type == %d", service.service_type)
        let titlePred = NSPredicate(format: "title == %@", service.title!)
        let msgPred = NSPredicate(format: "message == %@", service.message!)
        let phonePred = NSPredicate(format: "phone == %@", service.phone!)
        let namePred = NSPredicate(format: "name == %@", service.name!)
        
        let compound: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [latPred, longPred, rangePred, servPred, titlePred, msgPred, phonePred, namePred])
        
        fetchRequest.predicate = compound
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fetchRequest)
            let services = result as! [ServiceEntity]
            
            if services.count > 0 {
                coreDataContext.managedObjectContext.delete(services[0])
                coreDataContext.saveContext(coreDataContext.managedObjectContext)
            }
            
        } catch {
            print("Unable to fetch service to delete from data store")
            abort()
        }
    }
    
    func isServiceRunning() -> Bool {
        var running = false
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServiceRunning")
        let predicate = NSPredicate(format: "id == %d", 0)
        
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fetchRequest)
            let serviceRunning = result as! [ServiceRunning]
            
            if serviceRunning.count > 0 {
                running = serviceRunning[0].isRunning
            }
        } catch {
            print("Unable to retrieve ServiceRunning Entity from data store")
            abort()
        }
        return running
    }
    
    func toggleRunning() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServiceRunning")
        let predicate = NSPredicate(format: "id == %d", 0)
        
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fetchRequest)
            let serviceRunning = result as! [ServiceRunning]
            
            if serviceRunning.count > 0 {
                serviceRunning[0].isRunning = !serviceRunning[0].isRunning
                coreDataContext.saveContext()
            }
        } catch {
            print("Unable to retrieve ServiceRunning Entity to toggle from data store")
            abort()
        }
    }
    
    func insertServiceRunning() {
//        if !hasInsertedServiceRunning() {
//            let toInsert = NSEntityDescription.insertNewObject(forEntityName: "ServiceRunning", into: coreDataContext.backgroundContext!) as! ServiceRunning
//            
//            toInsert.id = 0
//            toInsert.isRunning = false
//            
//            coreDataContext.saveContext()
//        } else {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServiceRunning")
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let result = try coreDataContext.managedObjectContext.fetch(fetchRequest)
                let serviceRunning = result as! [ServiceRunning]
                
                if serviceRunning.count > 0 {
                    serviceRunning[0].isRunning = false
                } else {
                    let toInsert = NSEntityDescription.insertNewObject(forEntityName: "ServiceRunning", into: coreDataContext.backgroundContext!) as! ServiceRunning
                    toInsert.id = 0
                    toInsert.isRunning = false
                }
                coreDataContext.saveContext()
            } catch {
                print("Unable to retrieve ServiceRunning Entity to check insertion from data store")
                abort()
            }
//        }
    }
    
    func hasInsertedServiceRunning() -> Bool {
        var hasInserted = false
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServiceRunning")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try coreDataContext.managedObjectContext.fetch(fetchRequest)
            let serviceRunning = result as! [ServiceRunning]
            
            if serviceRunning.count > 0 {
                hasInserted = true
            }
        } catch {
            print("Unable to retrieve ServiceRunning Entity to check insertion from data store")
            abort()
        }
        return hasInserted
    }
}




















