//
//  ViewController.swift
//  Concentration
//
//  Created by Seokhwan Moon on 28/09/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // add 1 to round up for the odd number of cards
    // - lazy does not initialized before someone use it -> but no property observer can be lazy
    // - usually model can be public, but below game should be private since numberOfParsOfcards is tied to our UI
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // this variable should be private(set) but since there is only getter, it leaves to be public
    var numberOfPairsOfCards: Int {
        // if it is read only, a `get` keyword can be ignored
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
  
    // Outlet or Action always needs to be private
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber  = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel() // model needs to make view to change
        } else {
            print("chosen card was not in cardButtons")
        }
        
    }
    
    // updating model is an internal implementation (private)
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private var emojiChoices = ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎", "🧙‍♀️"]
    
    // dictionary Dictionary<Int, String>
    private var emoji = [Int: String]()
    
    private func emoji(for card: Card) -> String {
        // switft use comma to `and` if conditions
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            // do not allow duplicate
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            
        }
        
        // dictionary returns optional
//        if emoji[card.identifier] != nil {
//            return emoji[card.identifier]!  // get actual value since we know it is set to something
//        } else {
//            return "?"
//        }
        // simpler syntax
        return emoji[card.identifier] ?? "?"
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
