//
//  CoreDataSaveOps.swift
//  CoreDataProject
//
//  Created by dirtbag on 12/3/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import CoreData

class CoreDataSaveOps {
    let coreDataManager = CoreDataManager.shared
    let context = CoreDataManager.shared.mainContext
    static let shared = CoreDataSaveOps()
    
    private init() {}
    
    func saveUser(userObject: UserModel) {
        
        let userManagedObject = User(context: context)
        userManagedObject.email = userObject.email
        userManagedObject.password = userObject.password
        
        coreDataManager.saveContext(context: context)
    }
}
