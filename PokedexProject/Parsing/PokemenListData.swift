//
//  PokemonListData.swift
//  PokedexProject
//
//  Created by dirtbag on 12/12/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

struct PokemenListData: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonNameURL]?
}

struct PokemonNameURL: Codable {
    var id: Int?
    var name: String
    var url: String
    var imageURL: String?
    var imageData: Data?
}
