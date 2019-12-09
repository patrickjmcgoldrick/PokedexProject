//
//  ImageLoader.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

class ImageLoader {
    
    // Given a Pokemon id, load the PokemonForm, then get
    // the 'front_default' image into the given ImageView
    func loadPokemonImage(id: Int, imageLoaded: @escaping (Data) -> Void) {
        
        let url = "\(K.ServiceURL.getPokemonForm)\(id)"
        
        let network = NetworkController()
        network.loadPokemonData(urlString: url) { (data) in
            
            let parser = PokemonFormParser()
            parser.parse(data: data) { (formData) in
                if let imageUrl = formData.sprites?.front_default {
                    
                    network.loadPokemonData(urlString: imageUrl) { (data) in
                        
                        imageLoaded(data)
                    }
                }
            }
        }
    }
}
