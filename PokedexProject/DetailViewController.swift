//
//  DetailViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UISearchBarDelegate {

    var pokemon: Pokemon?
    
    
    @IBOutlet weak var detailPane: UIView!
    
    @IBOutlet weak var evolutionPane: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = pokemon?.name {
            print(name)
            navigationController?.navigationItem.title = name
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
}
