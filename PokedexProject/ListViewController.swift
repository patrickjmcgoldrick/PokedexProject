//
//  ViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allLoadedSoFar = [Pokemon]()
    var pokemen = [Pokemon]()
    var defaultImage = UIImage(named: "defaultPokemon")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPokemon(offset: 0)
        //CoreDataDeleteOps.shared.deleteAllPokemen()
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        if let destination = segue.destination as? DetailViewController {            
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
    
    private func updatePokemon(id: Int, imageView: UIImageView) {
        ImageLoader().loadPokemonImage(id: id) { (imageURL, data) in
                        
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
}

extension ListViewController: UICollectionViewDelegate {
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
