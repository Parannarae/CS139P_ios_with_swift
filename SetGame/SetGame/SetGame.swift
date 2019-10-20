//
//  SetGame.swift
//  SetGame
//
//  Created by Seokhwan Moon on 20/10/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import Foundation


class SetGame {
    private(set) var cardDeck: [Card]!
    private(set) var playingBoard: [Card] = []
    
    init() {
        initCardDeck()
        initPlayingBoard()
    }
    
    private func initCardDeck() {
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
    
    func drawCard() -> Card? {
        return cardDeck.popLast()
    }
    
    private func initPlayingBoard() {
        for _ in 1...12 {
            if let card = drawCard() {
                playingBoard.append(card)
            }
        }
    }
}
