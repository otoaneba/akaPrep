//
//  Persistence.swift
//  akaPrep
//
//  Created by Naoto Abe on 6/25/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        printCoreData(in: viewContext)
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "akaPrep")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static func printCoreData(in context: NSManagedObjectContext) {
        context.performAndWait {

                let entities = context.persistentStoreCoordinator?.managedObjectModel.entities
                for entity in entities ?? [] {
                    print("Printing data for entities: \(entity.name ?? "Unknown")")
                //                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                //                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                //                    try context.execute(deleteRequest)
                //                }
                //                try context.save()
                //            } catch {
                //                let nsError = error as NSError
                //                print("Error clearing data: \(nsError), \(nsError.userInfo)")
                //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    
            }
        }
    }
    
    static func clearAllData(in context: NSManagedObjectContext) {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch let error as NSError {
                print("Could not clear TaskEntity data: \(error), \(error.userInfo)")
            }
            
            let fetchRequestList: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "ListEntity")
            let deleteRequestList = NSBatchDeleteRequest(fetchRequest: fetchRequestList)
            
            do {
                try context.execute(deleteRequestList)
                try context.save()
            } catch let error as NSError {
                print("Could not clear ListEntity data: \(error), \(error.userInfo)")
            }
        }
}
