//
//  PokemonAnnotation.swift
//  Pokemon
//
//  Created by Enrique V. Kortright on 5/6/17.
//  Copyright © 2017 Enrique V. Kortright. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotation : NSObject, MKAnnotation {
    var pokemon : Pokemon
    var coordinate: CLLocationCoordinate2D
    
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.pokemon = pokemon
        self.coordinate = coord
    }

}
