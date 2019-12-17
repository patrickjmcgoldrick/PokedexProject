//
//  PokemonData.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

struct PokemonData: Codable {
    var abilities: [Abilities]
    var base_experience: Int
    var stats: [Stats]
    var species: Species
    var height: Int
    var weight: Int
}

struct Abilities: Codable {
    var ability: Ability
}

struct Ability: Codable {
    var name: String
    var url: String
}

struct Stats: Codable {
    var base_stat: Int
    var stat: Stat
}

struct Stat: Codable {
    var name: String
}

struct Species: Codable {
    var name: String
    var url: String
}

struct Type: Codable {
    var name: String
}
