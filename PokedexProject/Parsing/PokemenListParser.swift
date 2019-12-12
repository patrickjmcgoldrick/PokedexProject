//
//  PokemenParser.swift
//  PokedexProject
//
//  Created by dirtbag on 12/7/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

class PokemenListParser {
    
    func parse(data: Data, parsed: @escaping (PokemenListData) -> Void) {
                     
        // background the loading / parsing elements
        DispatchQueue.global(qos: .background).async {

            do {

                // create decoder
                let jsonDecoder = JSONDecoder()

                // decode json into structs
                let header = try jsonDecoder.decode(PokemenListData.self, from: data)

                parsed(header)
           
            } catch {
                print("Error Parsing JSON: \(error.localizedDescription)")
            }
        }
    }
}
