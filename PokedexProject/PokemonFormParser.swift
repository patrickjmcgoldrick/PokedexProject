//
//  PokemonFormParser.swift
//  PokedexProject
//
//  Created by dirtbag on 12/8/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

class PokemonFormParser {
    
    func parse(data: Data, parsed: @escaping (PokemonFormData) -> Void) {
                     
        // background the loading / parsing elements
        DispatchQueue.global(qos: .background).async {

            do {

                // create decoder
                let jsonDecoder = JSONDecoder()

                // decode json into structs
                let formData = try jsonDecoder.decode(PokemonFormData.self, from: data)

                parsed(formData)
           
            } catch {
                print("Error Parsing FormData JSON: \(error.localizedDescription)")
            }
        }
    }
}
