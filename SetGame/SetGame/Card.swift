//
//  Card.swift
//  SetGame
//
//  Created by Seokhwan Moon on 20/10/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import Foundation


struct Card {
    var number: SetNumber
    var shape: SetShape
    var shading: SetShading
    var color: SetColor
    
    enum SetNumber: Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var all = [SetNumber.one, .two, .three]
    }
    
    enum SetShape {
        case diamond
        case squiggle
        case oval
        
        static var all = [SetShape.diamond, .squiggle, .oval]
    }
    
    enum SetShading {
        case solid
        case striped
        case open
        
        static var all = [SetShading.solid, .striped, .open]
    }
    
    enum SetColor {
        case red
        case green
        case purple
        
        static var all = [SetColor.red, .green, .purple]
    }
}
