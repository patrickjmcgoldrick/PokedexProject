//
//  EvolutionData.swift
//  PokedexProject
//
//  Created by dirtbag on 12/10/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//
import Foundation

struct EvolutionData: Codable {
    var chain: Evolution?
}

struct Evolution: Codable {
    var evolves_to: [Evolution]
    var species: Species?
}

struct Species: Codable {
    var name: String?
    var url: String?
}
