//
//  CardView.swift
//  PokedexProject
//
//  Created by dirtbag on 12/12/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
