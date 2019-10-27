//
//  SetGame.swift
//  SetGame
//
//  Created by Seokhwan Moon on 20/10/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import Foundation


class SetGame {
    private(set) var cardDeck: [Card] = []
    private(set) var playingBoard: [Card] = []
    
    init() {
        initCardDeck()
        initPlayingBoard()
    }
    
    private func initCardDeck() {
        // set cardDeck with shuffled cards
        for number in Card.SetNumber.all {
            for shape in Card.SetShape.all {
                for shading in Card.SetShading.all {
                    for color in Card.SetColor.all {
                        cardDeck.append(Card(number: number, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
        // shuffle the deck
        cardDeck.shuffle()
    }
    
    private func drawThreeCards() -> [Card]? {
        // draw three cards
        var res: [Card] = []
        for _ in 1...3 {
            if let card = cardDeck.popLast() {
                res.append(card)
            }
        }
        
        return res
    }
    
    func dealThreeCards() {
        // draw three cards and put them in the appropriate place
        //  - if matched cards exist, replace them with new cards
        //  - else append to the end of the playingBoard
        let cards = drawThreeCards()!
        
        if !cards.isEmpty {
            let matched_card_indices = playingBoard.filter { ($0 != nil) && ($0!.isMatched == true) }.map { playingBoard.firstIndex(of: $0)! }
            
            assert(matched_card_indices.count == 3 || matched_card_indices.count == 0, "SetGame.dealThreeCards(): a number of matched cards is not 0 or 3 but \(matched_card_indices.count)")
            
            if !matched_card_indices.isEmpty {
                // swap new cards with matched cards
                for index in matched_card_indices {
                    playingBoard[index] = cards[index]
                }
            } else {
                playingBoard.append(contentsOf: cards)
            }
        }
    }
    
    private func initPlayingBoard() {
        // place 12 cards from cardDeck
        for _ in 1...4 {
            dealThreeCards()
        }
    }
    
    private func checkSet(with cards: [Card]) -> Bool {
        return cards.areSet()
    }
    
    private func resetChosenCards() {
        if let chosenCards = playingBoard.chosenCards {
            for card in chosenCards {
                card.isSelected = false
            }
        }
    }
    
    func chooseCard(at index: Int) {
        assert(playingBoard.indices.contains(index), "SetGame.chooseCard(at: \(index)): chosen index is not in the playing board.")
        
        let card = playingBoard[index]
        
        if card.isSelected == false {
            card.isSelected = true
            if let chosenCards = playingBoard.chosenCards, chosenCards.count == 3 {
                if checkSet(with: chosenCards){
                    _ = chosenCards.map { $0.isMatched = true }
                } else{
                    resetChosenCards()
                }
            }
        }
    }
}

extension Array where Element: Card {
    func areSet() -> Bool {
        // check if cards in array are Set
        if self.count == 3 {
            var cardNumberSet = Set<Card.SetNumber>()
            var cardShapeSet = Set<Card.SetShape>()
            var cardShadingSet = Set<Card.SetShading>()
            var cardColorSet = Set<Card.SetColor>()
            
            for index in self.indices {
                let card = self[index]
                cardNumberSet.insert(card.number)
                cardShapeSet.insert(card.shape)
                cardShadingSet.insert(card.shading)
                cardColorSet.insert(card.color)
            }
            
            return (
                (cardNumberSet.count == 1 || cardNumberSet.count == 3)
                && (cardShapeSet.count == 1 || cardShapeSet.count == 3)
                && (cardShadingSet.count == 1 || cardShadingSet.count == 3)
                && (cardColorSet.count == 1 || cardColorSet.count == 3)
            )
            
        }
        return false
    }
    
    var chosenCards: [Card]? {
        // return only chosen cards
        return self.filter { $0.isSelected }
    }
}
