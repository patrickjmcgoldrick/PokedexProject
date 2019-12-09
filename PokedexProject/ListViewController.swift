//
//  ViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var pokemen = [PokemonData]()
    var defaultImage = UIImage(named: "defaultPokemon")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPokemon(pageNumber: 10)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func loadPokemon(pageNumber: Int) {
        NetworkController().loadPokemonData(urlString: K.ServiceURL.getPokemen) { (data) in
            print (data.description)
            
            let parser = PokemenParser()
            parser.parse(data: data) { (pokemenHeader) in
                
                if let results = pokemenHeader.results {
                    self.pokemen = results
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
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
            ImageLoader().loadPokemonImage(id: (indexPath.row + 1)) { (data) in
                
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data)
                }
                // TODO: cache image data
                let updatePokemon = PokemonData(name: pokemon.name, url: pokemon.url, imageData: data)
                self.pokemen[indexPath.row] = updatePokemon
            }
        }
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    
    
    
}

