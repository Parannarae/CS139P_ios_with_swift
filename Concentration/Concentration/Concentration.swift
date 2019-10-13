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
    var score = 0
    var alreadySeenCardIdentifiers: [Card] = []
    
    // to check the status of current game
    // optional to make the case when there is no card is opened yet
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func iSSeenBefore(card: Card) -> Bool {
        // check if card is ever seen before
        if !alreadySeenCardIdentifiers.contains(card) {
            alreadySeenCardIdentifiers.append(card)
            return false
        }

        return true
    }
    
    func penalize(card: Card) {
        // score -1 if card is aleady seen before
        if iSSeenBefore(card: card) {
            score -= 1
        }
    }
    
    func chooseCard(at index: Int) {
        // ignore card if it is already matched
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // second card is chosen
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    // increment score
                    score += 2
                } else {
                    penalize(card: cards[matchIndex])
                    penalize(card: cards[index])
                }
                // open up the card and reset the previously opened card
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    // reset all cards to be faced down for the case when two cards are already faced up
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        // countable range: `..<` = exclude last, `...` = include last
        for _ in 0..<numberOfPairsOfCards { // `_` means ignore it
            let card = Card()
            cards += [card, card]
        }
        
        // Shuffle the cards
        cards.shuffle()
    }
}
