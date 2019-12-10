//
//  CoreDataManager.swift
//  CoreDataProject
//
//  Created by dirtbag on 12/3/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let dataModelName = "PokedexProject"

    private init() {}

    // MARK: - Setup Core Data stack

    var mainContext: NSManagedObjectContext {
        let viewContext =  persistentContainer.viewContext
        //viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        
        let context = persistentContainer.newBackgroundContext()
        //context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)

        let description = NSPersistentStoreDescription()
            description.url = NSPersistentContainer.defaultDirectoryURL()
                .appendingPathComponent(dataModelName + ".sqlite")

            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    assertionFailure("Unresolved error \(error), \(error.userInfo)")
                }
            })

       return container
    }()

    // MARK: - Save Method
    func saveContext(context: NSManagedObjectContext) {
       do {
           try context.save()
       } catch {
           print("Could not save of: \(error)")
       }
    }

    // MARK: - Read Methods
    func fetchObjects<T>(fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) -> [T] {
       do {
           return try context.fetch(fetchRequest)
       } catch {
           assertionFailure("Could not fetch because of: \(error)")
       }
       return []
    }
    
    func batchDelete(objects: [NSManagedObject], context: NSManagedObjectContext) {
        let objectIDs: [NSManagedObjectID] = objects.map { $0.objectID }
        let deleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            assertionFailure("Could not delete objects: \(error)")
        }
    }
}
