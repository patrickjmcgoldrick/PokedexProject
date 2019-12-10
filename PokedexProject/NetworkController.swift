//
//  NetworkController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

class NetworkController {

    func loadPokemonData(urlString: String, completed: @escaping (Data) -> Void) {

        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }

            completed(data)
        }
        task.resume()
    }
}
