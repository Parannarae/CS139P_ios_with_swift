//
//  Card.swift
//  Concentration
//
//  Created by Seokhwan Moon on 29/09/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp = false
    var isMatched = false
    // identifier is not containing an emoji information since model should be UI independent
    var identifier: Int
    
    // Card does not understance this, but type Card understand static
    static var identifierFactory = 0
    static func getUniqueIdentifier() -> Int {
        // since we are already in static method, Card does not has to be added to access its static method like Card.identifierFactory
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
