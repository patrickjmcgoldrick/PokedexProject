//
//  ViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet private weak var searchBar: UISearchBar!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet var longPressGuestureRec: UILongPressGestureRecognizer!
    
    var allLoadedSoFar = [Pokemon]()
    var pokemen = [Pokemon]()
    var favorites = [Favorite]()
    var gEmail = "x@y.com"
    var defaultImage = UIImage(named: K.Image.defaultPokemonImage)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // if we have not already loaded all the pokemen, then get to it.
        if UserDefaults.standard.bool(forKey: K.Key.allPokemenLoadedKey) != true {
            loadPokemon(urlString: K.ServiceURL.getPokemenInitial)
        } else {
            // load from CoreData
            print("Load data from CoreData")
            self.pokemen = CoreDataFetchOps.shared.getAllPokemen()
            self.allLoadedSoFar = self.pokemen
            collectionView.reloadData()
        }
        
        // setup delegates
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        longPressGuestureRec.delegate = self
       //TODO: Use global variable
        
        favorites = CoreDataFetchOps.shared.getFavoritesBy(email: gEmail)
    }
    
    private func loadPokemon(urlString: String) {
       
        NetworkController().loadPokemonData(urlString: urlString) { (data) in
            print(data.description)
            
            let parser = PokemenListParser()
            parser.parse(data: data) { (pokemenHeader) in
                
                if let results = pokemenHeader.results {
                    for result in results {
                        CoreDataSaveOps.shared.savePokemon(pokemon: result)
                    }
                    self.pokemen = CoreDataFetchOps.shared.getAllPokemen()
                    self.allLoadedSoFar = self.pokemen
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                    // if not nil, load nextset of data
                    if let nextURL = pokemenHeader.next {
                        print("next: \(nextURL)")
                        self.loadPokemon(urlString: nextURL)
                    } else {
                        UserDefaults.standard.set(true, forKey: K.Key.allPokemenLoadedKey)
                    }
                }
            }
        }
    }
       
    /// adapted from: https://stackoverflow.com/questions/18848725/long-press-gesture-on-uicollectionviewcell
    
    @IBAction private func longPressAction(_ sender: UILongPressGestureRecognizer) {

        if sender.state != .ended {
            return
        }
        
        let point = sender.location(in: self.collectionView)

        if let indexPath = self.collectionView.indexPathForItem(at: point) {

            // get the cell at indexPath (the one you long pressed)
            let pokemon = pokemen[indexPath.row]
            guard let cell = self.collectionView.cellForItem(at: indexPath) as? ListViewCell else { return }
            
            // flip favorite status
            if isFavorite(pokemonId: pokemon.id) {
                CoreDataDeleteOps.shared.deleteFavoriteBy(email: gEmail, pokemonId: pokemon.id)
                cell.ivFavorite.isHidden = true
            } else {
                CoreDataSaveOps.shared.saveFavorite(email: gEmail, pokemonId: pokemon.id)
                cell.ivFavorite.isHidden = false
            }
            favorites = CoreDataFetchOps.shared.getFavoritesBy(email: gEmail)
        } else {
            print("couldn't find index path")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if let destination = segue.destination as? DetailViewController {

            guard let index = collectionView.indexPathsForSelectedItems?.first?.row else { return }

            destination.pokemon = pokemen[index]

        } else {
            
            print(segue.destination.description)
        }
    }
}

extension ListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pokemen.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListViewCell
            else { return UICollectionViewCell() }
        
        let pokemon = pokemen[indexPath.row]
        cell.lblName.text = pokemon.name
        cell.ivFavorite.isHidden = !isFavorite(pokemonId: pokemon.id)
        // do we have the image already?
        if let imageData = pokemon.imageData {
            cell.imageView.image = UIImage(data: imageData)
        } else {
            // otherwise, load image and save for next time
            cell.imageView.image = defaultImage
            if pokemon.id != 0 {
                updatePokemon(id: Int(pokemon.id), imageView: cell.imageView)
            }
                /*
            else {
                updatePokemon(id: (indexPath.row + 1), imageView: cell.imageView)
            }
 */
        }
        return cell
    }
    
    private func updatePokemon(id: Int, imageView: UIImageView) {
        ImageLoader().loadPokemonImage(id: id) { (imageURL, data) in
            let pokemon = CoreDataFetchOps.shared.getPokemonById(id: Int16(id))
            if let pokemon = pokemon {
                pokemon.imageURL = imageURL
                pokemon.imageData = data
                CoreDataSaveOps.shared.savePokemon(pokemon: pokemon)
            }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    private func isFavorite(pokemonId: Int16) -> Bool {
        for favorite in favorites {
            if favorite.pokemonId == pokemonId {
                return true
            }
        }
        return false
    }
}

extension ListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.Segue.listToDetail, sender: self)
    }
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            
            pokemen = allLoadedSoFar

        } else {
            
            let limitedList = CoreDataFetchOps.shared.searchPokemenFor(substring: searchText)
            pokemen = limitedList
        }

        collectionView.reloadData()
    }
    
}
