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
    let backgroundContext = CoreDataManager.shared.backgroundContext
    static let shared = CoreDataSaveOps()
    
    private init() {}
    
    func saveUser(userObject: UserModel) {
        
        let userManagedObject = User(context: context)
        userManagedObject.email = userObject.email
        userManagedObject.password = userObject.password
        
        coreDataManager.saveContext(context: context)
    }
    
    func savePokemon(pokemon: PokemonData) {
        let pokemonMO = Pokemon(context: backgroundContext)
        pokemonMO.name = pokemon.name
        pokemonMO.detailURL = pokemon.url
        if let imageURL = pokemon.imageURL {
            pokemonMO.imageURL = imageURL
        } else {
            pokemonMO.imageURL = ""
        }
        pokemonMO.imageData = Data()
        let elems = pokemon.url.split(separator: "/")
        pokemonMO.id = Int16(elems[elems.count - 1].description) ?? 0
        
        coreDataManager.saveContext(context: backgroundContext)
    }
}
