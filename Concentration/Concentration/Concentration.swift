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
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        // no card is flipped yet
                        foundIndex = index
                    } else {
                        // this is the second flipped card
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            // if no argument is given, `newValue` is a default argument name
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        // ignore card if it is already matched
        if !cards[index].isMatched {
            // second card is chosen
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                // open up the card and reset the previously opened card
                cards[index].isFaceUp = true
                // this has done in getter
//                indexOfOneAndOnlyFaceUpcard = nil
            } else {
                // this has done in setter
//                // either no cards or 2 cards are face up
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false
//                }
//                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
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
