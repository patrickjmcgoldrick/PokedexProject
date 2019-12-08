//
//  NetworkController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import Foundation

class NetworkController {

    func loadDataFromURL(urlString: String, completed: @escaping (Data) -> ()) {

        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }

            print ("Data: \(String(bytes: data, encoding: .utf8)!)")

            completed(data)
        }
        task.resume()
    }
}
