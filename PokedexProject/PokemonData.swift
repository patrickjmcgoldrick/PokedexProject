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
    var id: Int?
    var name: String
    var url: String
    var imageURL: String?
    var imageData: Data?
}

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


