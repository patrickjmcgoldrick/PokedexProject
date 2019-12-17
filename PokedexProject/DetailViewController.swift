//
//  DetailViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet public weak var imageMain: UIImageView!
    
    @IBOutlet public weak var imageFavorited: UIImageView!
    
    @IBOutlet public weak var detailPane: UIView!
    
    @IBOutlet public weak var evolutionPane: UIView!
    
    @IBOutlet weak var scrollEvolutions: UIScrollView!
    
    var pokemon: Pokemon?
    var favorites = [Favorite]()
    
    var cards = [CardView]()
    
    var gEmail = "x@y.com"

    var cardSize = CGFloat(300.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createSlide()
        createSlide()
        createSlide()
        
        setupScrollView()
        
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
    
    private func createSlide() {

        let card = CardView()
    //slide.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: K.Image.defaultPokemonImage)
        card.imageView.image = image
        card.lblName.text = "Patrick"
        cards.append(card)
    }
    
    private func setupScrollView() {
        //scrollEvolutions.frame = CGRect(x: 0, y: 0, width: scrollEvolutions.frame.width, height: scrollEvolutions.frame.height)
        scrollEvolutions.contentSize = CGSize(width: cardSize * CGFloat(cards.count), height: scrollEvolutions.frame.height)
        //scrollEvolutions.isPagingEnabled = true

        // calculate x position to center image
        //let xPosition = (view.frame.width - scrollView.frame.width) / 2

        for index in 0..<cards.count {
            cards[index].frame = CGRect(x: cardSize * CGFloat(index),
                                         y: 0,
                                         width: cardSize,
                                         height: cardSize)
            scrollEvolutions.addSubview(cards[index])
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
