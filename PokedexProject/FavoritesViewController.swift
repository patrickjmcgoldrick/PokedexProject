//
//  SearchViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/9/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var pokemonIds: [Int16]?
    var pokemen = [Pokemon]()
    
    let gEmail = "x@y.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        setupFavoriteData()
    }
    
    func setupFavoriteData() {
        
        // get array of PokemonIds
        let favorites = CoreDataFetchOps.shared.getFavoritesBy(email: gEmail)
        pokemonIds = favorites.map { (favorite) -> Int16 in
            return favorite.pokemonId
        }
        print(pokemonIds)
        
        // read matching Pokemen from Database
        guard let ids = pokemonIds else { return }
        pokemen = CoreDataFetchOps.shared.getPokemenByIds(ids: ids)
        
        print(pokemen.count)
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = pokemen[indexPath.row].name
        print(pokemen[indexPath.row].name)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? DetailViewController else { return }
        
        if let row = tableView.indexPathForSelectedRow?.row {

            destination.pokemon = pokemen[row]
        }
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.Segue.favoriteToDetail, sender: self)
    }
}
