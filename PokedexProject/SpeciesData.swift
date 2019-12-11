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
}

struct EvolutionChain: Codable {
    var url: String?
}
