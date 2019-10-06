//
//  Card.swift
//  Concentration
//
//  Created by Seokhwan Moon on 29/09/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import Foundation

// inherit Hashable to use as a key of a dictionary
struct Card: Hashable
{
    var hashValue: Int { return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    // since view is not using it any more, make it private
    private var identifier: Int
    
    // Card instance does not understance this, but type Card understand static
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        // since we are already in static method, Card does not has to be added to access its static method like Card.identifierFactory
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
