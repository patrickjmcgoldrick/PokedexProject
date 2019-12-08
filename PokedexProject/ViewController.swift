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
        
        loadPokemon(pageNumber: 10)
    }
    
    private func loadPokemon(pageNumber: Int) {
        NetworkController().loadDataFromURL(urlString: K.ServiceURL.getPokemen) { (data) in
            print (data.description)
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

