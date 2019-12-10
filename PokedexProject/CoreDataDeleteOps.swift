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
    
    func deleteFavoriteBy(email: String, pokemonId: Int16) {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail = %@ AND pokemonId = %d", email, pokemonId)
        let favorites = coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context)
        if favorites.count != 0 {
            coreDataManager.batchDelete(objects: favorites, context: context)
        }
    }
}
