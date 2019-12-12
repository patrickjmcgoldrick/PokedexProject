//
//  DetailViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var imageMain: UIImageView!
    
    @IBOutlet weak var imageFavorited: UIImageView!
    
    
    
    
    @IBOutlet weak var detailPane: UIView!
    
    @IBOutlet weak var evolutionPane: UIView!
    
    var pokemon: Pokemon?
    var favorites = [Favorite]()
    var gEmail = "x@y.com"

    override func viewDidLoad() {
        super.viewDidLoad()

        favorites = CoreDataFetchOps.shared.getFavoritesBy(email: gEmail)

        if let pokemon = pokemon {
            if let data = pokemon.imageData {
                imageMain.image = UIImage(data: data)
            }
            if isFavorite(pokemonId: pokemon.id) {
                imageFavorited.isHighlighted = true
            }
            print(pokemon.imageURL)
        }
    }

    @IBAction private func segmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            view.sendSubviewToBack(evolutionPane)

        case 1:
            view.sendSubviewToBack(detailPane)
        default:
            break
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
