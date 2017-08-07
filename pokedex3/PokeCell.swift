//
//  PokeCell.swift
//  pokedex3
//
//  Created by Tolik Ivanov on 18/04/2017.
//  Copyright © 2017 Tolik Ivanov. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexid)")
        
    }
    
}
