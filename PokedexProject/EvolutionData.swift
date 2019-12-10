//
//  EvolutionData.swift
//  PokedexProject
//
//  Created by dirtbag on 12/10/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//
import Foundation
/*
struct EvolutionData: Codable {
    var chain: Evolution?
}

struct Evolution: Codable {
    //var evolution_details: EvoDetails?
    var evolves_to: EvolutionTo?
    var species: Species?
    
    init(evolves_to: EvolutionTo, species: Species) {
        self.evolves_to = evolves_to
        self.species = species
    }
}

struct EvolutionTo: Codable {
    //var evolution_details: EvoDetails?
    var evolves_to: EvolutionThree?
    var species: Species?
}

struct EvolutionThree: Codable {
    //var evolution_details: EvoDetails?
    var evolves_to: EvolutionFour?
    var species: Species?
}

struct EvolutionFour: Codable {
    //var evolution_details: EvoDetails?
    var species: Species?
}
*/
struct EvoDetails: Codable {
    var item: String?
}

struct Species {
    var name: String
    var url: String
}
