//
//  PokemonParser.swift
//  PokedexProject
//
//  Created by dirtbag on 12/12/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class PokemonParser {
    
    func parse(data: Data, parsed: @escaping (PokemonData) -> Void) {
                     
        // background the loading / parsing elements
        DispatchQueue.global(qos: .background).async {

            do {

                // create decoder
                let jsonDecoder = JSONDecoder()

                // decode json into structs
                let pokemonData = try jsonDecoder.decode(PokemonData.self, from: data)

                parsed(pokemonData)
           
            } catch {
                print("Error Parsing JSON: \(error.localizedDescription)")
            }
        }
    }
}
