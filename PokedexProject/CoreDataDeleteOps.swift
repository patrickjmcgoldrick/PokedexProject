//
//  CoreDataDeleteOps.swift
//  CoreDataClassDemo
//
//  Created by dirtbag on 12/3/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import CoreData

class CoreDataDeleteOps {
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.mainContext
    static let shared = CoreDataDeleteOps()
    
    func deleteAllPokemen() {
        let pokemen = CoreDataFetchOps.shared.getAllPokemen()
        print(pokemen.count)
        
        if pokemen.count != 0 {
            coreDataManager.batchDelete(objects: pokemen, context: context)
        }
    }
    
    func deleteBy(email: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)
        let sports = coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context)
        if sports.count != 0 {
            coreDataManager.batchDelete(objects: sports, context: context)
        }
    }
}
