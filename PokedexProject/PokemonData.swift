//
//  PokemonData.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

struct PokemenHeader: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonData]?
}

struct PokemonData: Codable {
    var name: String
    var url: String
    var imageData: Data?
}

struct PokemonFormData: Codable {
    var id: Int?
    var pokemon: Pokemon?
    var sprites: Sprites?
}

struct Pokemon: Codable {
    var name: String?
    var url: String?
}

struct Sprites: Codable {
    var front_default: String?
}


