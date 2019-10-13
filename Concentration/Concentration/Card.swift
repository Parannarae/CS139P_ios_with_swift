//
//  Card.swift
//  Concentration
//
//  Created by Seokhwan Moon on 29/09/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    var isFaceUp = false
    var isMatched = false
    // identifier is not containing an emoji information since model should be UI independent
    var identifier: Int
    
    // Card instance does not understance this, but type Card understand static
    static var identifierFactory = 0
    static func getUniqueIdentifier() -> Int {
        // since we are already in static method, Card does not has to be added to access its static method like Card.identifierFactory
        identifierFactory += 1
        return identifierFactory
    }
    
    /*
     Only use identifier to distinguish Card instance
     */
    static func ==(lhs:Card, rhs:Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
