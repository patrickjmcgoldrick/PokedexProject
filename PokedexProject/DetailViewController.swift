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
    
    @IBOutlet weak var lblFavoriteText: UILabel!
    
    // MARK: Detail Pane Outlets
    @IBOutlet weak var statId: StatView!
    
    @IBOutlet weak var statBaseExp: StatView!
    
    @IBOutlet weak var statHeight: StatView!
    
    @IBOutlet weak var statWeight: StatView!
    
    @IBOutlet public weak var detailPane: UIView!
    
    @IBOutlet weak var scrollDetails: UIScrollView!
    
    // MARK: Evolutions Pane Outlets
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
        
        scrollEvolutions.contentSize = CGSize(width: cardSize * CGFloat(cards.count), height: scrollEvolutions.frame.height)

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
    
    // MARK: Break Down Pokemon Service Data
    private func loadDetails() {
        
        guard let id = pokemon?.id else { return }
        
        let urlString = K.ServiceURL.getPokemon + String(id)

        network.loadData(urlString: urlString) { (data) in
             
            let parser = PokemonParser()
            parser.parse(data: data) { (pokemonData) in

                self.setStatistics(pokemonData: pokemonData)
                
                let speciesURL = pokemonData.species.url
                self.loadSpecies(urlString: speciesURL)

            }
        }
    }
    
    func setStatistics(pokemonData: PokemonData) {
        DispatchQueue.main.async {
            self.statId.lblName.text = "id:"
            self.statId.lblValue.text = String(pokemonData.id)
            self.statBaseExp.lblName.text = "Base Exp:"
            self.statBaseExp.lblValue.text = String(pokemonData.base_experience)
            self.statWeight.lblName.text = "Width:"
            self.statWeight.lblValue.text = String(pokemonData.weight)
            self.statHeight.lblName.text = "Height:"
            self.statHeight.lblValue.text = String(pokemonData.height)
            
            var lastView: UIView = self.statHeight
            
            for statData in pokemonData.stats {
                lastView = self.generateStatView(statData: statData, lastView: lastView)
            }
        }
    }
    
    func generateStatView(statData: StatData, lastView: UIView) -> UIView {
        let value = statData.base_stat
        print("Value: \(value)")
        let name = statData.stat.name
        var statsView: StatView = {
            var statView = StatView()
        
            statView.translatesAutoresizingMaskIntoConstraints = false
            statView.lblName.text = name
            statView.lblValue.text = String(value)
            return statView
        }()
        scrollDetails.addSubview(statsView)
        statsView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 8).isActive = true
        statsView.leadingAnchor.constraint(equalTo: scrollDetails.leadingAnchor, constant: 20).isActive = true
        statsView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        statsView.widthAnchor.constraint(equalToConstant: 171).isActive = true
        
        return statsView

    }
    
    // MARK: Break Down Species Service Data
    private func loadSpecies(urlString: String) {
        
        network.loadData(urlString: urlString) { (data) in
                        
            let parser = SpeciesParser()
            parser.parse(data: data) { (speciesData) in
                
                if let evolutionURL = speciesData.evolution_chain?.url {
                   
                    DispatchQueue.main.async {
                        self.lblFavoriteText.text = self.getFavoriteText_en(favorites: speciesData.flavor_text_entries)
                    }
                    self.loadEvolutions(urlString: evolutionURL)
                }
            }
        }
    }
    
    /// pick out Favorite text in english
    private func getFavoriteText_en(favorites: [FlavorText]) -> String {
        
        for favorite in favorites {
            if favorite.language.name == "en" {
                return favorite.flavor_text
            }
        }
        return ""
    }
    
    // MARK: Break Down Evolution Service Data
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
