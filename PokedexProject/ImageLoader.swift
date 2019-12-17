//
//  ImageLoader.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class ImageLoader {
    
    var imageURL: String?
    
    // Given a Pokemon id, load the PokemonForm, then get
    // the 'front_default' image into the given ImageView
    func loadPokemonImage(id: Int, imageLoaded: @escaping (String, Data) -> Void) {
        
        let url = "\(K.ServiceURL.getPokemonForm)\(id)"
        
        let network = NetworkController()
        network.loadData(urlString: url) { (data) in
            
            let parser = PokemonFormParser()
            parser.parse(data: data) { (formData) in
                self.imageURL = formData.sprites?.front_default
                if let imageURL = self.imageURL {
                    
                    network.loadData(urlString: imageURL) { (data) in
                        
                        imageLoaded(imageURL, data)
                    }
                }
            }
        }
    }
    
    func loadImageIntoView(imageURL: String, imageView: UIImageView) {
        
        NetworkController().loadData(urlString: imageURL) { (data) in
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }
    }
}
