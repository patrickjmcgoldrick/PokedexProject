//
//  StatView.swift
//  PokedexProject
//
//  Created by dirtbag on 12/17/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class StatView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblValue: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("StatView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.autoresizingMask = [ .flexibleWidth]

    }
    
}
