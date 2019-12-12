//
//  PokemonFormData.swift
//  PokedexProject
//
//  Created by dirtbag on 12/11/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

struct PokemonFormData: Codable {
    var id: Int?
    var pokemon: PokemonRow?
    var sprites: Sprites?
}

struct PokemonRow: Codable {
    var name: String?
    var url: String?
}

struct Sprites: Codable {
    var front_default: String?
}
