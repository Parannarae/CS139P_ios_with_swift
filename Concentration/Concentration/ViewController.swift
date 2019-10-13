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
    let emojiThemeDict = [  // possible card themes to choose
        "halloween": ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎", "🧙‍♀️"],
        "animal": ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯"],
        "sport": ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🥏", "🎱", "🏓"],
        "expression": ["😀", "😅", "😂", "🤣", "😇" ,"😍", "😘", "🤩", "😱", "🤔"],
        "food": ["🌭", "🍔", "🍟", "🍕", "🥙", "🥗", "🥘" ,"🍝", "🍱", "🥟"],
        "transport": ["🚗", "🚕", "🚌", "🛴", "🚲", "🛵", "🚃", "🚄", "✈️", "⛴"]
    ]
    var emojiChoices: [String]!     // an Array of emoji to use for current game
    var emoji = [Card: String]()    // a map of Card to emoji
    
    var game: Concentration!
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    var scoreCount = 0 {
        didSet {
            scoreLabel.text = "Score: \(scoreCount)"
        }
    }
  
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
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
    
    func updateLabelValues() {
        // apply flip count and score
        flipCount = game.flipCount
        scoreCount = game.score
    }
    
    func emoji(for card: Card) -> String {
        // get associated emoji of card
        return emoji[card] ?? "?"
    }
    
    func updateViewFromModel() {
        // update card display
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
        updateLabelValues()
    }
    
    func bindCardWithEmoji() {
        // get random theme and assign an emoji to each card pair
        let curThemeElement = emojiThemeDict.randomElement()!
        emojiChoices = curThemeElement.value
        for card in game.cards {
            if emoji[card] == nil, emojiChoices.count > 0 {
                // pseudo random number generator (exclude upper bound)
                // need to convert int to unsigned int
                let randomIndex = emojiChoices.count.arc4random()
                
                // do not allow duplicate
                emoji[card] = emojiChoices.remove(at: randomIndex)
            }
        }
    }

    func startNewGame() {
        // initialize a game
        // add 1 to round up for the odd number of cards
        game = Concentration(numberOfPairsOfCards: ((cardButtons.count + 1) / 2))
        
        updateLabelValues()
        bindCardWithEmoji()
        
        // redraw the contents
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        startNewGame()
    }
}

extension Int {
    func arc4random() -> Int{
        // get random integer from 0 upto self
        return Int(arc4random_uniform(UInt32(self)))
    }
}
