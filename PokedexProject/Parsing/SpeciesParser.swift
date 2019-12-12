//
//  PokemonSpeciesParser.swift
//  PokedexProject
//
//  Created by dirtbag on 12/10/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

class SpeciesParser {

    func parse(data: Data, parsed: @escaping (SpeciesData) -> Void) {
                     
        // background the loading / parsing elements
        DispatchQueue.global(qos: .background).async {

            do {

                // create decoder
                let jsonDecoder = JSONDecoder()

                // decode json into structsspeciesData
                let speciesData = try jsonDecoder.decode(SpeciesData.self, from: data)

                parsed(speciesData)
           
            } catch {
                print("Error Parsing JSON: \(error.localizedDescription)")
            }
        }
    }
}
