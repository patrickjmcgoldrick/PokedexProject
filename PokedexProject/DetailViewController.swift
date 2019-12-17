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
    var evolutionPokemen = [Pokemon]()
    var network = NetworkController()
    
    var cards = [CardView]()
    
    var gEmail = "x@y.com"

    var cardSize = CGFloat(300.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
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
            
            loadDetails()
        }
    }
    
    private func createSlide(name: String, imageURL: String) {

        let card = CardView()
        //let image = UIImage(named: K.Image.defaultPokemonImage)
        ImageLoader().loadImageIntoView(imageURL: imageURL, imageView: card.imageView)
        card.lblName.text = name
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
    
    private func loadDetails() {
        
        guard let id = pokemon?.id else { return }
        
        let urlString = K.ServiceURL.getPokemon + String(id)

        network.loadData(urlString: urlString) { (data) in
             
             let parser = PokemonParser()
             parser.parse(data: data) { (pokemonData) in
                 
                let speciesURL = pokemonData.species.url
                    
                self.loadSpecies(urlString: speciesURL)
                
            }
         }
    }
    
    private func loadSpecies(urlString: String) {
        
        network.loadData(urlString: urlString) { (data) in
                        
            let parser = SpeciesParser()
            parser.parse(data: data) { (speciesData) in
                
                if let evolutionURL = speciesData.evolution_chain?.url {
                    self.loadEvolutions(urlString: evolutionURL)
                } else {
                    print("FAILED TO GET HERE!")
                }
            }
        }
    }
    
    private func loadEvolutions(urlString: String) {
        
        network.loadData(urlString: urlString) { (data) in
            let parser = EvolutionParser()
            parser.parse(data: data) { (evolutionData) in
                
                var evolutions = [Species]()
                evolutions.append(evolutionData.chain.species)
                var step = evolutionData.chain.evolves_to
                
                while step.count > 0 {
                    evolutions.append(step[0].species)
                    step = step[0].evolves_to
                }
                
                var ids = [Int16]()
                for record in evolutions {
                    ids.append(self.getIdFromUrl(urlString: record.url))
                }
                
                print ("ids: \(ids)")
                self.evolutionPokemen = CoreDataFetchOps.shared.getPokemenByIds(ids: ids)
                
                DispatchQueue.main.async {
                    for pokemon in self.evolutionPokemen {
                        guard let name = pokemon.name else { continue }
                        guard let imageURL = pokemon.imageURL else { continue }
                        print(name)
                        print("image at: \(imageURL)")
                        self.createSlide(name: name, imageURL: imageURL)
                        self.setupScrollView()
                    }
                }
            
            }
        }
    }
    
    private func getIdFromUrl(urlString: String) -> Int16 {
        
        let elements = urlString.split(separator: "/")
        return Int16(String(elements[elements.count - 1])) ?? 0
    }
}
