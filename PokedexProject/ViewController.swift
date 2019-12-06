//
//  ViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var pokemen = [PokemonData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func parseFeedData(data: Data) {
                     
        // background the loading / parsing elements
        DispatchQueue.global(qos: .background).async {

            do {

                // create decoder
                let jsonDecoder = JSONDecoder()

                // decode json into structs
                let temp = try jsonDecoder.decode([PokemonData].self, from: data)

           
            } catch {
                print("Error Parsing JSON: \(error.localizedDescription)")
            }

            DispatchQueue.main.async {
                
                //self.tvPosts.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if let destination = segue.destination as? DetailViewController {
            
        }
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

