//
//  CoreDataFetchOps.swift
//  CoreDataClassDemo
//
//  Created by dirtbag on 12/3/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import CoreData

class CoreDataFetchOps {
    
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.mainContext
    static let shared = CoreDataFetchOps()
    
    private init() {}
    
    func getAllUsers() -> [User] {

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        return coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context)
    }
    
    func getFavoritesBy(email: String) -> [Favorite] {

        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail=%@", email)
        return coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context)
    }
    
    func getUserby(email: String) -> [User] {

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email=%@", email)
        return coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context)
    }
    
    func getAllPokemen() -> [Pokemon] {

        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        return coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context)
    }
    
    func searchPokemenFor(substring: String) -> [Pokemon] {

        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", substring)
        return coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context)
    }
    
    func getPokemenByIds(ids: [Int16]) -> [Pokemon] {

        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
        return coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context)
    } 
}
