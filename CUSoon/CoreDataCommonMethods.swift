//
//  CoreDataCommonMethods.swift
//  CUSoon
//
//  Created by:
//      Brooke Borges
//      Chad Lewis
//      Jeremy Olsen
//  Copyright © 2017 Capstone. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataCommonMethods: NSObject {
    
    static var dataStore = CoreDataStore()
    
    override init(){
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(CoreDataCommonMethods.contextDidSaveContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        // Return a managed object context that is tied to the persistent store that we have created.
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = dataStore.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext? = {
        
        var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = dataStore.persistentStoreCoordinator
        return backgroundContext
    }()
    
    
    func saveContext (_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // add appropriate code to provide a better feedback.
                NSLog("Unable to save context.")
                abort()
            }
        }
    }
    
    func saveContext () {
        self.saveContext( self.backgroundContext! )
    }
    
    func contextDidSaveContext(_ notification: Notification) {
        
        let sender = notification.object as! NSManagedObjectContext
        if sender === self.managedObjectContext {
            self.backgroundContext!.perform {
                self.backgroundContext!.mergeChanges(fromContextDidSave: notification)
            }
        } else if sender === self.backgroundContext {
            self.managedObjectContext.perform {
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            }
        } else {
            self.backgroundContext!.perform {
                self.backgroundContext!.mergeChanges(fromContextDidSave: notification)
            }
            self.managedObjectContext.perform {
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
}
