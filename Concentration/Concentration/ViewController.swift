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
    var game: Concentration!
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
  
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            startNewGame()
        }
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber  = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel() // model needs to make view to change
        } else {
            print("chosen card was not in cardButtons")
        }
        
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        startNewGame()
    }
    
    func updateViewFromModel() {
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
    
    let emojiSet = ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎", "🧙‍♀️"]
    var emojiChoices: [String]!
    
    // dictionary Dictionary<Int, String>
    var emoji = [Int: String]()
    
    func bindCardWithEmoji() {
        emojiChoices = emojiSet
        for card in game.cards {
            if emoji[card.identifier] == nil, emojiChoices.count > 0 {
                // pseudo random number generator (exclude upper bound)
                // need to convert int to unsigned int
                let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
                
                // do not allow duplicate
                emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
            }
        }
    }
    
    func emoji(for card: Card) -> String {
        return emoji[card.identifier] ?? "?"
    }
    
    func startNewGame() {
        flipCount = 0
        // add 1 to round up for the odd number of cards
        game = Concentration(numberOfPairsOfCards: ((cardButtons.count + 1) / 2))
        bindCardWithEmoji()
        // redraw the contents
        updateViewFromModel()
    }
}


