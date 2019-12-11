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

        static let getPokemen = "https://pokeapi.co/api/v2/pokemon"
        
        static let getPokemonForm = "https://pokeapi.co/api/v2/pokemon-form/"
    }
    
    struct Segue {
        
        static let loggedIn = "loggedInSegue"
    }
    struct TestCase {
        
        static let expectedPokemenCount = 964
    }
    
    struct Image {
        
        static let defaultImage = "defaultPokemon"
    }
}
