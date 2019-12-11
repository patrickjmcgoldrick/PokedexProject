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
    var defaultImage = UIImage(named: K.Image.defaultImage)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPokemon(offset: 0)
        //CoreDataDeleteOps.shared.deleteAllPokemen()
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        longPressGuestureRec.delegate = self
       //TODO: Use global variable
        
        favorites = CoreDataFetchOps.shared.getFavoritesBy(email: gEmail)
        print(favorites)
    }
    
    private func loadPokemon(offset: Int) {
       
        let url = "\(K.ServiceURL.getPokemen)?offset=\(offset)&limit=100"
        NetworkController().loadPokemonData(urlString: url) { (data) in
            print(data.description)
            
            let parser = PokemenParser()
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
            } else {
                updatePokemon(id: (indexPath.row + 1), imageView: cell.imageView)
            }
        }
        return cell
    }
    
    private func isFavorite(pokemonId: Int16) -> Bool {
        for favorite in favorites {
            if favorite.pokemonId == pokemonId {
                return true
            }
        }
        return false
    }
    
    private func updatePokemon(id: Int, imageView: UIImageView) {
        ImageLoader().loadPokemonImage(id: id) { (imageURL, data) in
                        
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
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
