//
//  EvolutionParser.swift
//  PokedexProject
//
//  Created by dirtbag on 12/10/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//
import Foundation

class EvolutionParser {

    func parse(data: Data, parsed: @escaping (EvolutionData) -> Void) {
                     
        // background the loading / parsing elements
        DispatchQueue.global(qos: .background).async {

            do {

                // create decoder
                let jsonDecoder = JSONDecoder()

                // decode json into structs
                let evolutionData = try jsonDecoder.decode(EvolutionData.self, from: data)

                parsed(evolutionData)
           
            } catch {
                print("Error Parsing JSON: \(error.localizedDescription)")
            }
        }
    }
}
