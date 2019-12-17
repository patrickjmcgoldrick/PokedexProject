//
//  SpeciesData.swift
//  PokedexProject
//
//  Created by dirtbag on 12/10/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

struct SpeciesData: Codable {
    var evolution_chain: EvolutionChain?
    var flavor_text_entries: [FlavorText]
}

struct EvolutionChain: Codable {
    var url: String?
}

struct FlavorText: Codable {
    var flavor_text: String
    var language: NameUrl
}

struct NameUrl: Codable {
    var name: String
    var url: String
}
