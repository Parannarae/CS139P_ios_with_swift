//
//  Card.swift
//  SetGame
//
//  Created by Seokhwan Moon on 20/10/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import Foundation


class Card: Equatable, CustomStringConvertible {
    let number: SetNumber
    let shape: SetShape
    let shading: SetShading
    let color: SetColor
    
    var isSelected = false
    var isMatched = false
    
    var description: String {
        return "Card: \(self.number)/\(self.shape)/\(self.shading)/\(self.color)"
    }
    
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
    
    init(number: SetNumber, shape: SetShape, shading: SetShading, color: SetColor) {
        self.number = number
        self.shape = shape
        self.shading = shading
        self.color = color
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number
            && lhs.shape == rhs.shape
            && lhs.shading == rhs.shading
            && lhs.color == rhs.color
    }
}
