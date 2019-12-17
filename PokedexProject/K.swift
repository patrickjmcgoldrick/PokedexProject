//
//  K.swift
//  PokedexProject
//
//  Created by dirtbag on 12/8/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

struct K {
    
    struct ServiceURL {

        static let getPokemenInitial = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=100"
        
        static let getPokemonForm = "https://pokeapi.co/api/v2/pokemon-form/"
    }
    
    struct Segue {
        
        static let loggedIn = "loggedInSegue"
        
        static let listToDetail = "listToDetail"
        
        static let favoriteToDetail = "favoriteToDetail"
    }
    
    struct TestCase {
        
        static let expectedPokemenCount = 964
    }
    
    struct Image {
        
        static let defaultPokemonImage = "defaultPokemon"
        
        static let defaultUserImage = "surf-board"
    }
    
    struct Key {
        
        static let allPokemenLoadedKey = "all_pokemen_loaded_key"
    }
    
    struct Setting {
        
        static let allPokemenLoadedDefault = false
    }
}
