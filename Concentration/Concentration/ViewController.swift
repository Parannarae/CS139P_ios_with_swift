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
    
    var scoreCount = 0 {
        didSet {
            scoreLabel.text = "Score: \(scoreCount)"
        }
    }
  
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
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
    
    override func viewDidLoad() {
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
        
        // apply score
        scoreCount = game.score
    }
    
    let emojiThemeDict = [
        "halloween": ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎", "🧙‍♀️"],
        "animal": ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯"],
        "sport": ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🥏", "🎱", "🏓"],
        "expression": ["😀", "😅", "😂", "🤣", "😇" ,"😍", "😘", "🤩", "😱", "🤔"],
        "food": ["🌭", "🍔", "🍟", "🍕", "🥙", "🥗", "🥘" ,"🍝", "🍱", "🥟"],
        "transport": ["🚗", "🚕", "🚌", "🛴", "🚲", "🛵", "🚃", "🚄", "✈️", "🚀", "⛴"]
    ]
    
    var emojiChoices: [String]!
    
    // dictionary Dictionary<Int, String>
    var emoji = [Card: String]()
    
    func bindCardWithEmoji() {
        // get random theme
        let curThemeElement = emojiThemeDict.randomElement()!
        print("\(curThemeElement.key) theme is chosen!")
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
    
    func emoji(for card: Card) -> String {
        return emoji[card] ?? "?"
    }
    
    func startNewGame() {
        flipCount = 0
        scoreCount = 0
        // add 1 to round up for the odd number of cards
        game = Concentration(numberOfPairsOfCards: ((cardButtons.count + 1) / 2))
        bindCardWithEmoji()
        // redraw the contents
        updateViewFromModel()
    }
}

extension Int {
    func arc4random() -> Int{
        return Int(arc4random_uniform(UInt32(self)))
    }
}
