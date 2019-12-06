//
//  ImageLoader.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

class ImageLoader {
    
    func loadImage(urlString: String, imageLoaded: @escaping (Data) -> Void) {
                
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in

            guard let data = data else { return }

             imageLoaded(data)
        }.resume()
    }
}
