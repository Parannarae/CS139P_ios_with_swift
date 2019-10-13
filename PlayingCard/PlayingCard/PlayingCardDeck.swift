//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Seokhwan Moon on 13/10/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import Foundation

struct PlayingCardDeck
{
    private(set) var cards = [PlayingCard]()
    
    init() {
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                // since it is struct, we have automatic init
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    // struct variable needs to be mutated (remove)
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
}


extension Int {
    // pseudo random number generator (exclude upper bound)
    // need to convert int to unsigned int
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        // deal with edge cases
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
