//
//  DetailViewController.swift
//  PokedexProject
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = pokemon?.name {
            navigationController?.navigationBar.topItem?.title = name
        }
    }
}
