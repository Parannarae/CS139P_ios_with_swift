//
//  Concentration.swift
//  Concentration
//
//  Created by Seokhwan Moon on 29/09/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import Foundation

class Concentration
{
    var cards = [Card]()
    
    // to check the status of current game
    // optional to make the case when there is no card is opened yet
    var indexOfOneAndOnlyFaceUpcard: Int?
    
    func chooseCard(at index: Int) {
        // ignore card if it is already matched
        if !cards[index].isMatched {
            // second card is chosen
            if let matchIndex = indexOfOneAndOnlyFaceUpcard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                // open up the card and reset the previously opened card
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpcard = nil
            } else {
                // either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpcard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        // countable range: `..<` = exclude last, `...` = include last
        for _ in 0..<numberOfPairsOfCards { // `_` means ignore it
            let card = Card()
//            let matchingCard = card // since struct is pass by value, it creates another Card
//            cards.append(card)
//            cards.append(matchingCard)
            
//            cards.append(card)
//            cards.append(card) // same as set matchingCard
            
            cards += [card, card]
        }
        
        // TODO: Shuffle the cards
    }
}
